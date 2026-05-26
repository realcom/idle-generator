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

const parsing = Blockly.utils.parsing;

const UnattachedFieldError = Blockly.UnattachedFieldError;

const WidgetDiv = Blockly.WidgetDiv;
const eventUtils = Blockly.Events;

const dom = Blockly.utils.dom;
const userAgent = Blockly.utils.userAgent;
const Coordinate = Blockly.utils.Coordinate;
const Svg = Blockly.utils.Svg;

const Field = Blockly.Field;
const FieldInput = Blockly.FieldTextInput;
const FieldDropdown = Blockly.FieldDropdown;

export class AutocompleteField extends Blockly.FieldTextInput {
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
    return new AutocompleteField(varName, undefined, options);
  }

  doValueUpdate_(newValue: string) {
    super.doValueUpdate_(newValue);
    if (typeof newValue != 'string') {
      this.value_ = null;
    }
    const autocomplete = (newValue: string) => {
      if (!this.htmlInput_) return '';
      const options = Array.from((this.htmlInput_.list as HTMLDataListElement).options);
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
    let borderRadius = FieldInput.BORDERRADIUS * scale + 'px';

    if (this.isFullBlockField()) {
      const bBox = this.getScaledBBox();

      // Override border radius.
      borderRadius = (bBox.bottom - bBox.top) / 2 + 'px';
      // Pull stroke colour from the existing shadow block
      const strokeColour = block.getParent()
        ? (block.getParent() as BlockSvg).style.colourTertiary
        : (this.sourceBlock_ as BlockSvg).style.colourTertiary;
      htmlInput.style.border = 1 * scale + 'px solid ' + strokeColour;
      div.style.borderRadius = borderRadius;
      div.style.transition = 'box-shadow 0.25s ease 0s';
      if (this.getConstants().FIELD_TEXTINPUT_BOX_SHADOW) {
        div.style.boxShadow =
          'rgba(255, 255, 255, 0.3) 0 0 0 ' + 4 * scale + 'px';
      }
    }
    htmlInput.style.borderRadius = borderRadius;

    div.appendChild(htmlInput);
    htmlInput.value = htmlInput.defaultValue = this.getEditorText_(this.value_);
    htmlInput.setAttribute('data-untyped-default-value', String(this.value_));
    htmlInput.setAttribute('autocomplete', 'off')

    this.resizeEditor_();

    this.bindInputEvents_(htmlInput);

    // add dropdown options
    htmlInput.setAttribute('list', this.validOptions_);

    htmlInput.addEventListener('click', (e: Event) => {
      e.stopPropagation();
      const temp = (e.target as HTMLInputElement).value;
      (e.target as HTMLInputElement).value = '';
      e.target.dispatchEvent(new Event('input', {
        bubbles: true,
        cancelable: true,
      }));
      setTimeout(()=>{(
        e.target as HTMLInputElement).value = temp;
        }, 1);
    });

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

  positionSVGArrow(x: number, y: number) {
    if (!this.svgArrow) {
      return 0;
    }
    const block = this.getSourceBlock();
    if (!block) {
      throw new UnattachedFieldError();
    }
    const hasBorder = !!this.borderRect_;
    const xPadding = hasBorder
      ? this.getConstants().FIELD_BORDER_RECT_X_PADDING
      : 0;
    const textPadding = this.getConstants().FIELD_DROPDOWN_SVG_ARROW_PADDING;
    const svgArrowSize = this.getConstants().FIELD_DROPDOWN_SVG_ARROW_SIZE;
    const arrowX = block.RTL ? xPadding : x + textPadding;
    this.svgArrow.setAttribute(
      'transform',
      'translate(' + arrowX + ',' + y + ')',
    );
    return svgArrowSize + textPadding;
  }

}