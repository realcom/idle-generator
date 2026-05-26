import * as Blockly from "blockly";
import {
  Menu,
  MenuItem,
  MenuGenerator,
  MenuOption,
  FieldTextInputConfig,
  FieldTextInputValidator,
  BlockSvg
} from "blockly";

import Awesomplete, {SortFunction} from "awesomplete";

import "./nextautocomplete.css";

const parsing = Blockly.utils.parsing;

const UnattachedFieldError = Blockly.UnattachedFieldError;

const WidgetDiv = Blockly.WidgetDiv;
const eventUtils = Blockly.Events;

const dom = Blockly.utils.dom;
const Svg = Blockly.utils.Svg;

const Field = Blockly.Field;
const FieldInput = Blockly.FieldTextInput;
const FieldDropdown = Blockly.FieldDropdown;

export class NextAutocompleteField extends Blockly.FieldTextInput {
  static CHECKMARK_OVERHANG = 25;
  static MAX_MENU_HEIGHT_VH = 0.45;
  static ARROW_CHAR = '▾';

  selectedMenuItem: MenuItem = null;
  menu_: Menu = null;
  imageElement: SVGImageElement = null;
  arrow: SVGTSpanElement = null;
  svgArrow: SVGElement = null;
  SERIALIZABLE = true;
  CURSOR = 'default';
  menuGenerator_: MenuGenerator;
  generatedOptions: MenuOption[] = null;
  prefixField: string = null;
  suffixField: string = null;
  selectedOption: MenuOption = null;
  clickTarget_: SVGElement = null;

  validOptions_ = '';

  initializing_ = true;
  comboplete: Awesomplete = null;

  constructor(
    value?: string | typeof Field.SKIP_SETUP,
    validator?: FieldTextInputValidator | null,
    config?: FieldTextInputConfig,
  ) {
    super(value, validator, config);
  }

  fromJson(options: any) {
    const varName = parsing.replaceMessageReferences(options.variable);
    // `this` might be a subclass of FieldVariable if that class doesn't
    // override the static fromJson method.
    return new NextAutocompleteField(varName, undefined, options);
  }

  doValueUpdate_(newValue: string) {
    super.doValueUpdate_(newValue);
    if (typeof newValue != 'string') {
      this.value_ = null;
    }
    const autocomplete = (newValue: string) => {
      if (!this.htmlInput_) return '';
      const options = Array.from((document.getElementById(this.validOptions_) as HTMLDataListElement).options);
      const match = options.filter(element => element.value.toLowerCase().includes(newValue.toLowerCase()));
      if (match.length) return match[0].value;
      return '';
    }
    this.value_ = autocomplete(newValue);
  }

  initView() {
    if (this.shouldAddBorderRect_()) {
      this.createBorderRect_();
    } else {
      this.clickTarget_ = (this.sourceBlock_ as BlockSvg).getSvgRoot();
    }
    this.createTextElement_();

    this.imageElement = dom.createSvgElement(Svg.IMAGE, {}, this.fieldGroup_);

    this.createTextArrow_();

    if (this.borderRect_) {
      dom.addClass(this.borderRect_, 'blocklyDropdownRect');
    }
  }

  shouldAddBorderRect_() {
    return (
      !this.getConstants().FIELD_DROPDOWN_NO_BORDER_RECT_SHADOW ||
      (this.getConstants().FIELD_DROPDOWN_NO_BORDER_RECT_SHADOW &&
        !this.getSourceBlock()?.isShadow())
    );
  }

  createTextArrow_() {
    this.arrow = dom.createSvgElement(Svg.TSPAN, {}, this.textElement_);
    this.arrow.appendChild(
      document.createTextNode(
        this.getSourceBlock()?.RTL
          ? FieldDropdown.ARROW_CHAR + ' '
          : ' ' + FieldDropdown.ARROW_CHAR,
      ),
    );
    this.arrow.setAttribute('fill', (this.sourceBlock_ as BlockSvg).style.colourPrimary);

    if (this.getConstants().FIELD_TEXT_BASELINE_CENTER) {
      this.arrow.setAttribute('dominant-baseline', 'central');
    }
    if (this.getSourceBlock()?.RTL) {
      this.getTextElement().insertBefore(this.arrow, this.textContent_);
    } else {
      this.getTextElement().appendChild(this.arrow);
    }
  }

  widgetCreate_() {
    const block = this.getSourceBlock();
    if (!block) {
      throw new UnattachedFieldError();
    }
    eventUtils.setGroup(true);
    const div = WidgetDiv.getDiv();

    const clickTarget = this.getClickTarget_();
    if (!clickTarget) throw new Error('A click target has not been set.');
    dom.addClass(clickTarget, 'editing');

    const htmlInput = document.createElement('input');
    htmlInput.className = 'blocklyHtmlInput';
    // AnyDuringMigration because:  Argument of type 'boolean' is not assignable
    // to parameter of type 'string'.
    htmlInput.setAttribute(
      'spellcheck',
      this.spellcheck_ as any,
    );
    const scale = this.workspace_.getScale();
    const fontSize = this.getConstants().FIELD_TEXT_FONTSIZE * scale + 'pt';
    div.style.fontSize = fontSize;
    htmlInput.style.fontSize = fontSize;
    const borderRadius = FieldInput.BORDERRADIUS * scale + 'px';

    htmlInput.style.borderRadius = borderRadius;
    htmlInput.placeholder = this.value_;

    div.appendChild(htmlInput);

    const dataListElement = document.getElementById(this.validOptions_) as HTMLDataListElement;
    const validOptions: string[] = [];
    for (let i = 0; i < dataListElement.options.length; i++) {
      validOptions.push((dataListElement.options[i] as HTMLOptionElement).value);
    }

    this.comboplete = new Awesomplete(htmlInput, {
      list: validOptions,
      minChars: 0,
      autoFirst: true,
      maxItems: 1000,
      sort: false
    });

    (Awesomplete.$('.blocklyHtmlInput') as HTMLElement).addEventListener('click', (e: any) => {
      console.log('click')
      if (this.comboplete.ul.childNodes.length === 0) {
        this.comboplete.evaluate();
      }
      else if (this.comboplete.ul.hasAttribute('hidden')) {
        this.comboplete.open();
      }
      else {
        this.comboplete.close();
      }
    });

    (Awesomplete.$('.blocklyHtmlInput') as HTMLElement).addEventListener('awesomplete-selectcomplete', (e: any) => {
      this.setValue(e.text.value);
    });

    this.resizeEditor_();

    this.bindInputEvents_(htmlInput);

    return htmlInput;
  }

  loadState(state: any) {
    if (this.loadLegacyState(Field, state)) {
      return;
    }
    this.value_ = state;
  }

  render_() {
    // Hide both elements.
    this.getTextContent().nodeValue = '';

    // Retrieves the selected option to display through getText_.
    this.getTextContent().nodeValue = this.getDisplayText_();
    const textElement = this.getTextElement();
    dom.addClass(textElement, 'blocklyDropdownText');
    textElement.setAttribute('text-anchor', 'start');

    // Height and width include the border rect.
    const hasBorder = !!this.borderRect_;
    const height = Math.max(
      hasBorder ? this.getConstants().FIELD_DROPDOWN_BORDER_RECT_HEIGHT : 0,
      this.getConstants().FIELD_TEXT_HEIGHT,
    );
    if (this.initializing_) {
      this.initializing_ = false;
    } else if (/\s/.test(this.getTextContent().nodeValue)) {
      return;
    }
    const textWidth = dom.getFastTextWidth(
      this.getTextElement(),
      this.getConstants().FIELD_TEXT_FONTSIZE,
      this.getConstants().FIELD_TEXT_FONTWEIGHT,
      this.getConstants().FIELD_TEXT_FONTFAMILY,
    );
    const xPadding = hasBorder
      ? this.getConstants().FIELD_BORDER_RECT_X_PADDING
      : 0;
    const arrowWidth = 0;
    this.size_.width = textWidth + arrowWidth + xPadding * 2;
    this.size_.height = height;

    this.positionTextElement_(xPadding, textWidth);

    this.positionBorderRect_();
  }

}