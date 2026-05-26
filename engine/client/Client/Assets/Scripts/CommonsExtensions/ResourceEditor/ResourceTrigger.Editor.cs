//make's by hormon

#if UNITY_EDITOR
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using Commons.Resources;
using Commons.Game;
using Google.Protobuf;
using Google.Protobuf.Collections;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Serialization;
using StatementType = Commons.Resources.ResourceTrigger.Types.Type;
using OperatorType = Commons.Resources.ResourceTrigger.Types.Expression.Types.Operator.Types.Type;

namespace Commons.Resources
{
    public partial class ResourceTrigger
    {
        private static readonly string path = Path.Combine(Application.dataPath, "PatchResources/Triggers.json");
        
        private static Dictionary<string, ResourceTriggerEditorParser> triggerParsers = null;
        private static void LoadTriggerParsers()
        {
            if (triggerParsers != null)
                return;
            
            //Load to json
            var json = File.ReadAllText(path);
            var triggers = JsonParser.Default.Parse<Resources>(json).Triggers;
            Reload(triggers);
            
            //Convert to resource => parser
            triggerParsers = _triggerByName.Values
                .Select(trigger => (ResourceTriggerEditorParser)trigger)
                .ToDictionary(x => x.name);
        }
        
        public static void RefreshTriggerParsers()
        {
            //Load to json
            var json = File.ReadAllText(path);
            var triggers = JsonParser.Default.Parse<Resources>(json).Triggers;
            Reload(triggers);
            
            //Convert to resource => parser
            triggerParsers = _triggerByName.Values
                .Select(trigger => (ResourceTriggerEditorParser)trigger)
                .ToDictionary(x => x.name);
        }

        public static IEnumerable<ResourceTriggerEditorParser> GetTriggerParsers()
        {
            LoadTriggerParsers();
            return triggerParsers.Values;
        }
        
        public static IEnumerable<string> GetTriggerParserNamePaths()
        {
            return GetTriggerParserItems()
                .Where(x => x.name.Contains('/'))
                .Select(x => $"Triggers/{x.name[..x.name.LastIndexOf('/')]}")
                .Append("Triggers");
        }

        public static IEnumerable<ResourceTriggerEditorParser> GetTriggerParserItems()
        {
            return GetTriggerParsers().OrderBy(x => x.name);
        }

        public static IEnumerable<string> GetTriggerParserNames()
        {
            return GetTriggerParserItems().Select(x => x.name);
        }
        
        public static void AddTriggerParser(ResourceTriggerEditorParser triggerParser)
        {
            LoadTriggerParsers();
            triggerParsers[triggerParser.name] = triggerParser;
        }
        
        public static void RemoveTriggerParser(ResourceTriggerEditorParser triggerParser)
        {
            LoadTriggerParsers();
            triggerParsers.Remove(triggerParser.name);
        }

        public static void ConvertFromParser()
        {
            _triggerByName = triggerParsers.Values
                .Select(parser => (ResourceTrigger)parser)
                .ToDictionary(x => x.Name);
        }
        
    }
}

[InlineProperty]
[Serializable]
public class TriggerSelector
{
    [HideLabel, ValueDropdown("GetTriggerNames", DropdownTitle = "Select Trigger")]
    public string trigger = null;

    private IEnumerable GetTriggerNames()
    {
        return ResourceTrigger.GetTriggerParserNames();
    }

    public static implicit operator TriggerSelector(string trigger)
    {
        return new TriggerSelector()
        {
            trigger = trigger
        };
    }

    public static implicit operator string(TriggerSelector triggerSelector)
    {
        return triggerSelector.trigger;
    }
}

public abstract class OneOfElement
{
    public override string ToString()
    {
        return GetType().Name;
    }
}

[Serializable]
public class ResourceTriggerEditorParser
{
    public static IEnumerable GetOneOfTypes(System.Type type)
    {
        var derivedTypes = type.Assembly
            .GetTypes()
            .Where(t => !t.IsAbstract)
            .Where(t => t.IsSubclassOf(type));

        return derivedTypes.Select(x => new ValueDropdownItem(x.Name, Activator.CreateInstance(x)));
    }

    public abstract class StatementElement : OneOfElement
    {
    }

    [Serializable]
    public class Expression
    {
        public abstract class OperElement : OneOfElement
        {
        }

        [Serializable]
        public class Operator : OperElement
        {
            public OperatorType type;
            
            public static implicit operator Operator(ResourceTrigger.Types.Expression.Types.Operator @operator)
            {
                return new Operator()
                {
                    type = @operator.Type,
                };
            }
            
            public static implicit operator ResourceTrigger.Types.Expression.Types.Operator(Operator @operator)
            {
                return new ResourceTrigger.Types.Expression.Types.Operator()
                {
                    Type = @operator.type,
                };
            }
        }

        [Serializable]
        public class Operand : OperElement
        {
            public abstract class OperandElement : OneOfElement
            {
            }

            [Serializable]
            public class Constant : OperandElement
            {
                public double value;
                
                public static implicit operator Constant(ResourceTrigger.Types.Expression.Types.Operand.Types.Constant constant)
                {
                    return new Constant()
                    {
                        value = constant.Value,
                    };
                }
                
                public static implicit operator ResourceTrigger.Types.Expression.Types.Operand.Types.Constant(Constant constant)
                {
                    return new ResourceTrigger.Types.Expression.Types.Operand.Types.Constant()
                    {
                        Value = constant.value,
                    };
                }
            }

            [Serializable]
            public class Variable : OperandElement
            {
                public abstract class VariableElement : OneOfElement
                {
                }

                [Serializable]
                public class BoardKey : VariableElement
                {
                    [HideReferenceObjectPicker] 
                    public EditorStringKey key = new(string.Empty, 0);
                }

                [Serializable]
                public class CallerKey : VariableElement
                {
                    [HideReferenceObjectPicker]
                    public EditorStringKey key = new(string.Empty, 0);
                }

                [Serializable]
                public class StateKey : VariableElement
                {
                    [HideReferenceObjectPicker]
                    public EditorStringKey key = new(string.Empty, 0);
                }
                
                [Serializable]
                public class UnitKey : VariableElement
                {
                    [HideReferenceObjectPicker] 
                    public EditorStringKey key = new(string.Empty, 0);
                }


                [Serializable]
                public class Parameter : VariableElement
                {
                    [HideReferenceObjectPicker]
                    public ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type type;
                    
                    public static implicit operator Parameter(ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter parameter)
                    {
                        return new Parameter()
                        {
                            type = parameter.Type,
                        };
                    }
                    
                    public static implicit operator ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter(Parameter parameter)
                    {
                        return new ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter()
                        {
                            Type = parameter.type,
                        };
                    }
                }

                [Serializable]
                public class ObjectVariable : VariableElement
                {
                    [FormerlySerializedAs("_this")] public bool _caller;
                    public ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.ObjectVariable.Types.Type type;
                    
                    public static implicit operator ObjectVariable(ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.ObjectVariable objectVariable)
                    {
                        return new ObjectVariable()
                        {
                            _caller = objectVariable.Caller,
                            type = objectVariable.Type,
                        };
                    }
                    
                    public static implicit operator ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.ObjectVariable(ObjectVariable objectVariable)
                    {
                        return new ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.ObjectVariable()
                        {
                            Caller = objectVariable._caller,
                            Type = objectVariable.type,
                        };
                    }
                }

                [Serializable]
                public class PredefinedVariable : VariableElement
                {
                    [HideReferenceObjectPicker]
                    public ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type type;
                    
                    public static implicit operator PredefinedVariable(ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable predefinedVariable)
                    {
                        return new PredefinedVariable()
                        {
                            type = predefinedVariable.Type,
                        };
                    }
                    
                    public static implicit operator ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable(PredefinedVariable predefinedVariable)
                    {
                        return new ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable()
                        {
                            Type = predefinedVariable.type,
                        };
                    }
                }

                [Serializable]
                public class CallerVariable : VariableElement
                {
                }

                [Serializable]
                public class BoardVariable : VariableElement
                {
                    [HideReferenceObjectPicker]
                    public ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.BoardVariable.Types.Type type;
                    
                    public static implicit operator BoardVariable(ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.BoardVariable boardVariable)
                    {
                        return new BoardVariable()
                        {
                            type = boardVariable.Type,
                        };
                    }
                    
                    public static implicit operator ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.BoardVariable(BoardVariable boardVariable)
                    {
                        return new ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.BoardVariable()
                        {
                            Type = boardVariable.type,
                        };
                    }
                }

                [Serializable]
                public class UnitVariable : VariableElement
                {
                    [FormerlySerializedAs("_this")] [HideReferenceObjectPicker]
                    public bool _caller;
                    [HideReferenceObjectPicker]
                    public ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable.Types.Type type;
                    
                    public static implicit operator UnitVariable(ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable unitVariable)
                    {
                        return new UnitVariable()
                        {
                            _caller = unitVariable.Caller,
                            type = unitVariable.Type,
                        };
                    }
                    
                    public static implicit operator ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable(UnitVariable unitVariable)
                    {
                        return new ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable()
                        {
                            Caller = unitVariable._caller,
                            Type = unitVariable.type,
                        };
                    }
                }

                [Serializable]
                public class SkillVariable : VariableElement
                {
                    [FormerlySerializedAs("_this")] [HideReferenceObjectPicker]
                    public bool _caller;
                    [HideReferenceObjectPicker]
                    public ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.SkillVariable.Types.Type type;
                    
                    public static implicit operator SkillVariable(ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.SkillVariable skillVariable)
                    {
                        return new SkillVariable()
                        {
                            _caller = skillVariable.Caller,
                            type = skillVariable.Type,
                        };
                    }
                    
                    public static implicit operator ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.SkillVariable(SkillVariable skillVariable)
                    {
                        return new ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.SkillVariable()
                        {
                            Caller = skillVariable._caller,
                            Type = skillVariable.type,
                        };
                    }
                }

                [Serializable]
                public class BuffVariable : VariableElement
                {
                    [FormerlySerializedAs("_this")] [HideReferenceObjectPicker]
                    public bool _caller;
                    [HideReferenceObjectPicker]
                    public ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.BuffVariable.Types.Type type;
                    
                    public static implicit operator BuffVariable(ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.BuffVariable buffVariable)
                    {
                        return new BuffVariable()
                        {
                            _caller = buffVariable.Caller,
                            type = buffVariable.Type,
                        };
                    }
                    
                    public static implicit operator ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.BuffVariable(BuffVariable buffVariable)
                    {
                        return new ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.BuffVariable()
                        {
                            Caller = buffVariable._caller,
                            Type = buffVariable.type,
                        };
                    }
                }

                [HideReferenceObjectPicker, ValueDropdown("variable_Getter")]
                public VariableElement variable;

                private IEnumerable variable_Getter()
                {
                    return GetOneOfTypes(typeof(VariableElement));
                }
                
                public static implicit operator Variable(ResourceTrigger.Types.Expression.Types.Operand.Types.Variable variable)
                {
                    return new Variable()
                    {
                        variable = variable.VariableCase switch
                        {
                            ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.VariableOneofCase.None => null,
                            ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.VariableOneofCase.BoardKey => new BoardKey() { key = variable.BoardKey },
                            ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.VariableOneofCase.CallerKey => new CallerKey() { key = variable.CallerKey },
                            ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.VariableOneofCase.StateKey => new StateKey() { key = variable.StateKey },
                            ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.VariableOneofCase.Parameter => (Parameter)variable.Parameter,
                            ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.VariableOneofCase.ObjectVariable => (ObjectVariable)variable.ObjectVariable,
                            ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.VariableOneofCase.PredefinedVariable => (PredefinedVariable)variable.PredefinedVariable,
                            // ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.VariableOneofCase.Caller => new CallerVariable(),
                            ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.VariableOneofCase.UnitKey => new UnitKey() { key = variable.UnitKey },
                            ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.VariableOneofCase.BoardVariable => (BoardVariable)variable.BoardVariable,
                            ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.VariableOneofCase.UnitVariable => (UnitVariable)variable.UnitVariable,
                            ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.VariableOneofCase.SkillVariable => (SkillVariable)variable.SkillVariable,
                            ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.VariableOneofCase.BuffVariable => (BuffVariable)variable.BuffVariable,
                            _ => throw new ArgumentOutOfRangeException()
                        }
                    };
                }

                public static implicit operator ResourceTrigger.Types.Expression.Types.Operand.Types.Variable(Variable variable)
                {
                    var resVariable = new ResourceTrigger.Types.Expression.Types.Operand.Types.Variable();

                    switch (variable.variable)
                    {
                        case BoardKey boardKey:
                            resVariable.BoardKey = boardKey.key;
                            break;
                        case CallerKey callerKey:
                            resVariable.CallerKey = callerKey.key;
                            break;
                        case StateKey stateKey:
                            resVariable.StateKey = stateKey.key;
                            break;
                        case Parameter parameter:
                            resVariable.Parameter = parameter;
                            break;
                        case ObjectVariable objectVariable:
                            resVariable.ObjectVariable = objectVariable;
                            break;
                        case PredefinedVariable predefinedVariable:
                            resVariable.PredefinedVariable = predefinedVariable;
                            break;
                        case CallerVariable _:
                            resVariable.Caller = true;
                            break;
                        case UnitKey unitKey:
                            resVariable.UnitKey = unitKey.key;
                            break;
                        case BoardVariable boardVariable:
                            resVariable.BoardVariable = boardVariable;
                            break;
                        case UnitVariable unitVariable:
                            resVariable.UnitVariable = unitVariable;
                            break;
                        case SkillVariable skillVariable:
                            resVariable.SkillVariable = skillVariable;
                            break;
                        case BuffVariable buffVariable:
                            resVariable.BuffVariable = buffVariable;
                            break;
                        default:
                            break;
                    }
                    
                    return resVariable;
                }
            }

            [HideReferenceObjectPicker, ValueDropdown("operand_Getter")]
            public OperandElement operand;

            private IEnumerable operand_Getter()
            {
                return GetOneOfTypes(typeof(OperandElement));
            }
            
            public static implicit operator Operand(ResourceTrigger.Types.Expression.Types.Operand operand)
            {
                return new Operand()
                {
                    operand = operand.OperandCase switch
                    {
                        ResourceTrigger.Types.Expression.Types.Operand.OperandOneofCase.None => null,
                        ResourceTrigger.Types.Expression.Types.Operand.OperandOneofCase.Constant => (Constant)operand.Constant,
                        ResourceTrigger.Types.Expression.Types.Operand.OperandOneofCase.Variable => (Variable)operand.Variable,
                        _ => throw new ArgumentOutOfRangeException()
                    }
                };
            }
            
            public static implicit operator ResourceTrigger.Types.Expression.Types.Operand(Operand operand)
            {
                var resOperand = new ResourceTrigger.Types.Expression.Types.Operand();
                switch (operand.operand)
                {
                    case Constant constant:
                        resOperand.Constant = constant;
                        break;
                    case Variable variable:
                        resOperand.Variable = variable;
                        break;
                    default:
                        break;
                }

                return resOperand;
            }
        }

        [Serializable]
        public class Element
        {
            [HideReferenceObjectPicker, ValueDropdown("element_Getter")]
            public OperElement element;

            private IEnumerable element_Getter()
            {
                return GetOneOfTypes(typeof(OperElement));
            }
            
            public static implicit operator Element(ResourceTrigger.Types.Expression.Types.Element element)
            {
                return new Element()
                {
                    element = element.ElementCase switch
                    {
                        ResourceTrigger.Types.Expression.Types.Element.ElementOneofCase.None => null,
                        ResourceTrigger.Types.Expression.Types.Element.ElementOneofCase.Operator => (Operator)element.Operator,
                        ResourceTrigger.Types.Expression.Types.Element.ElementOneofCase.Operand => (Operand)element.Operand,
                        _ => throw new ArgumentOutOfRangeException()
                    }
                };
            }
            
            public static implicit operator ResourceTrigger.Types.Expression.Types.Element(Element element)
            {
                var resElement = new ResourceTrigger.Types.Expression.Types.Element();
                switch (element.element)
                {
                    case Operator @operator:
                        resElement.Operator = new ResourceTrigger.Types.Expression.Types.Operator()
                        {
                            Type = @operator.type,
                        };
                        break;
                    case Operand operand:
                        resElement.Operand = operand;
                        break;
                    default:
                        break;
                }

                return resElement;
            }
        }

        [
            HideReferenceObjectPicker,
            ListDrawerSettings(DefaultExpandedState = true, ShowFoldout = false),
            Indent(-1),
        ]
        public RepeatedField<Commons.Resources.ResourceTrigger.Types.Expression.Types.Element> items = new();

        public static implicit operator Expression(ResourceTrigger.Types.Expression expression)
        {
            return new Expression()
            {
                items = expression.Postfix,
            };
        }
        
        public static implicit operator ResourceTrigger.Types.Expression(Expression expression)
        {
            var resExpression = new ResourceTrigger.Types.Expression();
            resExpression.Postfix.AddRange(expression.items);
            // resExpression.ConvertInfixToPostfix();
            
            return resExpression;
        }
    }

    [Serializable]
    public class Assignment : StatementElement
    {
        [HideReferenceObjectPicker]
        public Expression.Operand.Variable variable;

        [HideReferenceObjectPicker]
        public Expression expression;
        
        public static implicit operator Assignment(ResourceTrigger.Types.Assignment assignment)
        {
            return new Assignment()
            {
                variable = (Expression.Operand.Variable)assignment.Variable,
                expression = assignment.Expression,
            };
        }
        
        public static implicit operator ResourceTrigger.Types.Assignment(Assignment assignment)
        {
            return new ResourceTrigger.Types.Assignment()
            {
                Variable = (ResourceTrigger.Types.Expression.Types.Operand.Types.Variable)assignment.variable,
                Expression = assignment.expression,
            };
        }
    }

    [Serializable]
    public class Call : StatementElement
    {
        public abstract class CallElement : OneOfElement
        {
        }
        
        [Serializable]
        public class BoardMethod : CallElement
        {
            [HideReferenceObjectPicker]
            public ResourceTrigger.Types.Call.Types.BoardMethod.Types.Type type;
            
            public static implicit operator BoardMethod(ResourceTrigger.Types.Call.Types.BoardMethod mapMethod)
            {
                return new BoardMethod()
                {
                    type = mapMethod.Type,
                };
            }
            
            public static implicit operator ResourceTrigger.Types.Call.Types.BoardMethod(BoardMethod boardMethod)
            {
                return new ResourceTrigger.Types.Call.Types.BoardMethod()
                {
                    Type = boardMethod.type,
                };
            }
        }
        
        [Serializable]
        public class UnitMethod : CallElement
        {
            [HideReferenceObjectPicker]
            public ResourceTrigger.Types.Call.Types.UnitMethod.Types.Type type;
            
            public static implicit operator UnitMethod(ResourceTrigger.Types.Call.Types.UnitMethod unitMethod)
            {
                return new UnitMethod()
                {
                    type = unitMethod.Type,
                };
            }
            
            public static implicit operator ResourceTrigger.Types.Call.Types.UnitMethod(UnitMethod unitMethod)
            {
                return new ResourceTrigger.Types.Call.Types.UnitMethod()
                {
                    Type = unitMethod.type,
                };
            }
        }
        
        [Serializable]
        public class SkillMethod : CallElement
        {
            [HideReferenceObjectPicker]
            public ResourceTrigger.Types.Call.Types.SkillMethod.Types.Type type;
            
            public static implicit operator SkillMethod(ResourceTrigger.Types.Call.Types.SkillMethod skillMethod)
            {
                return new SkillMethod()
                {
                    type = skillMethod.Type,
                };
            }
            
            public static implicit operator ResourceTrigger.Types.Call.Types.SkillMethod(SkillMethod skillMethod)
            {
                return new ResourceTrigger.Types.Call.Types.SkillMethod()
                {
                    Type = skillMethod.type,
                };
            }
        }
        
        [Serializable]
        public class BuffMethod : CallElement
        {
            [HideReferenceObjectPicker]
            public ResourceTrigger.Types.Call.Types.BuffMethod.Types.Type type;
            
            public static implicit operator BuffMethod(ResourceTrigger.Types.Call.Types.BuffMethod buffMethod)
            {
                return new BuffMethod()
                {
                    type = buffMethod.Type,
                };
            }
            
            public static implicit operator ResourceTrigger.Types.Call.Types.BuffMethod(BuffMethod buffMethod)
            {
                return new ResourceTrigger.Types.Call.Types.BuffMethod()
                {
                    Type = buffMethod.type,
                };
            }
        }
        
        [Serializable]
        public class DebugMethod : CallElement
        {
            [HideReferenceObjectPicker]
            public ResourceTrigger.Types.Call.Types.DebugMethod.Types.Type type;
            
            public static implicit operator DebugMethod(ResourceTrigger.Types.Call.Types.DebugMethod debugMethod)
            {
                return new DebugMethod()
                {
                    type = debugMethod.Type,
                };
            }
            
            public static implicit operator ResourceTrigger.Types.Call.Types.DebugMethod(DebugMethod debugMethod)
            {
                return new ResourceTrigger.Types.Call.Types.DebugMethod()
                {
                    Type = debugMethod.type,
                };
            }
        }
        
        [Serializable]
        public class RunTrigger : CallElement
        {
            [
                ValueDropdown("GetTriggerParserItems", DropdownTitle = "Select Trigger", OnlyChangeValueOnConfirm = true), 
                BoxGroup
            ]
            public ResourceTriggerEditorParser trigger;
            
            private IEnumerable GetTriggerParserItems()
            {
                return ResourceTrigger.GetTriggerParserItems();
            }
            
            public static implicit operator RunTrigger(ResourceTrigger.Types.Call.Types.RunTrigger runTrigger)
            {
                return new RunTrigger()
                {
                    trigger = runTrigger.Trigger,
                };
            }
            
            public static implicit operator ResourceTrigger.Types.Call.Types.RunTrigger(RunTrigger runTrigger)
            {
                return new ResourceTrigger.Types.Call.Types.RunTrigger()
                {
                    Name = runTrigger.trigger.name,
                };
            }
        }

        [FormerlySerializedAs("_this")] [HideReferenceObjectPicker] 
        public bool _caller;
        [HideReferenceObjectPicker, ValueDropdown("method_Getter")]
        public CallElement method;
        [
            HideReferenceObjectPicker,
            ListDrawerSettings(DefaultExpandedState = true, ShowFoldout = false, DraggableItems = false), 
            Indent(-1)
        ]
        public List<ResourceTrigger.Types.Assignment> assignments = new();
        
        private IEnumerable method_Getter()
        {
            return GetOneOfTypes(typeof(CallElement));
        }
        
        public static implicit operator Call(ResourceTrigger.Types.Call call)
        {
            return new Call()
            {
                _caller = call.Caller,
                method = call.Method.MethodCase switch
                {
                    ResourceTrigger.Types.Call.Types.Method.MethodOneofCase.None => null,
                    ResourceTrigger.Types.Call.Types.Method.MethodOneofCase.BoardMethod => (BoardMethod)call.Method.BoardMethod,
                    ResourceTrigger.Types.Call.Types.Method.MethodOneofCase.UnitMethod => (UnitMethod)call.Method.UnitMethod,
                    ResourceTrigger.Types.Call.Types.Method.MethodOneofCase.SkillMethod => (SkillMethod)call.Method.SkillMethod,
                    ResourceTrigger.Types.Call.Types.Method.MethodOneofCase.BuffMethod => (BuffMethod)call.Method.BuffMethod,
                    ResourceTrigger.Types.Call.Types.Method.MethodOneofCase.DebugMethod => (DebugMethod)call.Method.DebugMethod,
                    ResourceTrigger.Types.Call.Types.Method.MethodOneofCase.RunTrigger => (RunTrigger)call.Method.RunTrigger,
                    _ => throw new ArgumentOutOfRangeException()
                },
                assignments = call.Assignments.Select(x => x).ToList(),
            };
        }
        
        public static implicit operator ResourceTrigger.Types.Call(Call call)
        {
            var resCall = new ResourceTrigger.Types.Call()
            {
                Caller = call._caller,
            };

            resCall.Method = new();
            switch (call.method)
            {
                case BoardMethod mapMethod:
                    resCall.Method.BoardMethod = mapMethod;
                    break;
                case UnitMethod unitMethod:
                    resCall.Method.UnitMethod = unitMethod;
                    break;
                case SkillMethod skillMethod:
                    resCall.Method.SkillMethod = skillMethod;
                    break;
                case BuffMethod buffMethod:
                    resCall.Method.BuffMethod = buffMethod;
                    break;
                case DebugMethod debugMethod:
                    resCall.Method.DebugMethod = debugMethod;
                    break;
                case RunTrigger runTrigger:
                    resCall.Method.RunTrigger = runTrigger;
                    break;
                default:
                    break;
            }
            
            resCall.Assignments.Clear();
            resCall.Assignments.AddRange(call.assignments.Select(x => (ResourceTrigger.Types.Assignment)x));

            return resCall;
        }
    }

    [Serializable]
    public class Return : StatementElement
    {
        public static implicit operator Return(ResourceTrigger.Types.Return @return)
        {
            return new Return();
        }
        
        public static implicit operator ResourceTrigger.Types.Return(Return @return)
        {
            return new ResourceTrigger.Types.Return();
        }
    }

    [Serializable]
    public class Break : StatementElement
    {
        public static implicit operator Break(ResourceTrigger.Types.Break @break)
        {
            return new Break();
        }
        
        public static implicit operator ResourceTrigger.Types.Break(Break @break)
        {
            return new ResourceTrigger.Types.Break();
        }
    }

    [Serializable]
    public class Continue : StatementElement
    {
        public static implicit operator Continue(ResourceTrigger.Types.Continue @continue)
        {
            return new Continue();
        }
        
        public static implicit operator ResourceTrigger.Types.Continue(Continue @continue)
        {
            return new ResourceTrigger.Types.Continue();
        }
    }

    [Serializable]
    public class Condition : StatementElement
    {
        [FormerlySerializedAs("condition")] [HideReferenceObjectPicker]
        public Expression expression;

        [HideReferenceObjectPicker, Searchable]
        public List<Statement> statements = new();
        
        public static implicit operator Condition(ResourceTrigger.Types.Condition condition)
        {
            return new Condition()
            {
                expression = condition.Expression,
                statements = condition.Statements.Select(x => (Statement)x).ToList(),
            };
        }
        
        public static implicit operator ResourceTrigger.Types.Condition(Condition condition)
        {
            var resCondition = new ResourceTrigger.Types.Condition()
            {
                Expression= condition.expression,
            };
            
            resCondition.Statements.Clear();
            resCondition.Statements.AddRange(condition.statements.Select(x => (ResourceTrigger.Types.Statement)x));

            return resCondition;
        }
    }

    [Serializable]
    public class Loop : StatementElement
    {
        [FormerlySerializedAs("condition")] [HideReferenceObjectPicker]
        public Expression expression;

        [HideReferenceObjectPicker, Searchable]
        public List<Statement> statements = new();
        
        public static implicit operator Loop(ResourceTrigger.Types.Loop loop)
        {
            return new Loop()
            {
                expression = loop.Expression,
                statements = loop.Statements.Select(x => (Statement)x).ToList(),
            };
        }
        
        public static implicit operator ResourceTrigger.Types.Loop(Loop loop)
        {
            var resLoop = new ResourceTrigger.Types.Loop()
            {
                Expression = loop.expression,
            };
            
            resLoop.Statements.Clear();
            resLoop.Statements.AddRange(loop.statements.Select(x => (ResourceTrigger.Types.Statement)x));

            return resLoop;
        }
    }


    [Serializable]
    public class Statement
    {
        public string comment;

        [HideReferenceObjectPicker, ValueDropdown("statement_Getter")]
        public StatementElement statement;

        private IEnumerable statement_Getter()
        {
            return GetOneOfTypes(typeof(StatementElement));
        }

        public static implicit operator Statement(ResourceTrigger.Types.Statement statement)
        {
            return new Statement()
            {
                comment = statement.Comment,
                statement = statement.StatementCase switch
                {
                    ResourceTrigger.Types.Statement.StatementOneofCase.None => null,
                    ResourceTrigger.Types.Statement.StatementOneofCase.Assignment => (Assignment)statement.Assignment,
                    ResourceTrigger.Types.Statement.StatementOneofCase.Call => (Call)statement.Call,
                    ResourceTrigger.Types.Statement.StatementOneofCase.Return => (Return)statement.Return,
                    ResourceTrigger.Types.Statement.StatementOneofCase.Break => (Break)statement.Break,
                    ResourceTrigger.Types.Statement.StatementOneofCase.Continue => (Continue)statement.Continue,
                    ResourceTrigger.Types.Statement.StatementOneofCase.Condition => (Condition)statement.Condition,
                    ResourceTrigger.Types.Statement.StatementOneofCase.Loop => (Loop)statement.Loop,
                    _ => throw new ArgumentOutOfRangeException()
                }
            };
        }

        public static implicit operator ResourceTrigger.Types.Statement(Statement statement)
        {
            var resStatement = new ResourceTrigger.Types.Statement()
            {
                Comment = statement.comment,
            };

            switch (statement.statement)
            {
                case Assignment assignment:
                    resStatement.Assignment = (ResourceTrigger.Types.Assignment)assignment;
                    break;
                case Call call:
                    resStatement.Call = (ResourceTrigger.Types.Call)call;
                    break;
                case Return _return:
                    resStatement.Return = (ResourceTrigger.Types.Return)_return;
                    break;
                case Break _break:
                    resStatement.Break = (ResourceTrigger.Types.Break)_break;
                    break;
                case Continue _continue:
                    resStatement.Continue = (ResourceTrigger.Types.Continue)_continue;
                    break;
                case Condition condition:
                    resStatement.Condition = (ResourceTrigger.Types.Condition)condition;
                    break;
                case Loop loop:
                    resStatement.Loop = (ResourceTrigger.Types.Loop)loop;
                    break;
                default:
                    break;
            }
            
            return resStatement;
        }
    }

    [Serializable]
    public class Variables
    {
        [Serializable]
        public class KeyValue
        {
            public int key;
            public float value;
        }

        [HideReferenceObjectPicker, Searchable]
        public List<KeyValue> KeyValues = new();
    }

    [HideInInspector]
    public string name;
    public uint period = 0;
    public StatementType type;
    
    [
        HideReferenceObjectPicker,
        ListDrawerSettings(DefaultExpandedState = true, ShowFoldout = false), 
        Indent(-1),
    ]
    public List<Statement> statements = new();

    public static implicit operator ResourceTriggerEditorParser(ResourceTrigger trigger)
    {
        return new ResourceTriggerEditorParser()
        {
            name = trigger.Name,
            type = trigger.Type,
            period = trigger.Period,
            statements = trigger.Statements.Select(x => (Statement)x).ToList(),
        };
    }
    
    public static implicit operator ResourceTrigger(ResourceTriggerEditorParser resourceTriggerEditorParser)
    {
        var trigger = new ResourceTrigger()
        {
            Name = resourceTriggerEditorParser.name,
            Type = resourceTriggerEditorParser.type,
            Period = resourceTriggerEditorParser.period,
        };
            
        trigger.Statements.Clear();
        trigger.Statements.AddRange(resourceTriggerEditorParser.statements.Select(x => (ResourceTrigger.Types.Statement)x));

        return trigger;
    }

    public override string ToString()
    {
        return name;
    }
}
#endif