{
  "blocks": {
    "blocks": [
      {
        "id": "?|6-YZD3;dbHn=(A_s9X",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "TYPE": "caller",
                "VAR": {
                  "id": "VwmPw+Go:-Dax{ZYx^QU"
                }
              },
              "id": "o+,4JHCZ:K2sgw1seHeL",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "|v[zX+UDt7YgPo05)Ui/",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "TYPE": "caller",
                    "VAR": {
                      "id": "Bg/9wxiGncUOClEB%%)_"
                    }
                  },
                  "id": "H}z.EKrKH/Kv:EwrC56f",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "NUM": 0
                        },
                        "id": "RJ0/J_N/}USpJpSsp;lK",
                        "type": "math_number"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "fields": {
                        "TYPE": "caller",
                        "VAR": {
                          "id": "]0zu%je|1A@@Ln|jk-#p"
                        }
                      },
                      "id": "Z,okpl^B=XilIvf6Ykc1",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "BOOL": "TRUE"
                            },
                            "id": "R)W80u`%5BQ^/n;lGi%[",
                            "type": "logic_boolean"
                          }
                        }
                      },
                      "type": "variables_set"
                    }
                  },
                  "type": "variables_set"
                }
              },
              "type": "variables_set"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "EQ"
              },
              "id": "xMT!iC/]`7fcDU;q{~BP",
              "inputs": {
                "A": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "]0zu%je|1A@@Ln|jk-#p"
                      }
                    },
                    "id": "Qxz!SlgO~X-~H!Z2Z$Cm",
                    "type": "variables_get"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "BOOL": "FALSE"
                    },
                    "id": "0^to3Z3,lxUzvK]FT|G6",
                    "type": "logic_boolean"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": 505,
        "y": 375
      },
      {
        "extraState": {
          "hasElse": true
        },
        "id": "0{MBGts=+.VBAbD|l,z3",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": {
                "hasElse": true
              },
              "id": "h=,[rL~ANilk0wtt^z}i",
              "inputs": {
                "DO0": {
                  "block": {
                    "extraState": {
                      "hasElse": true
                    },
                    "id": "y3^`a]5p}QqwS:%{Ar+Z",
                    "inputs": {
                      "DO0": {
                        "block": {
                          "extraState": {
                            "hasElse": true
                          },
                          "id": "kc;kKF:E(:fRI#jR~Y:J",
                          "inputs": {
                            "DO0": {
                              "block": {
                                "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                                "fields": {
                                  "NAME": "unitMethod:Stop",
                                  "THIS": true
                                },
                                "id": "cKL4#!4.+}HJLG+rsSij",
                                "next": {
                                  "block": {
                                    "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                                    "fields": {
                                      "NAME": "unitMethod:LookAtTarget",
                                      "THIS": true
                                    },
                                    "id": "q-XlssZSYsw5(#Rq|9:.",
                                    "next": {
                                      "block": {
                                        "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;}]\"></mutation>",
                                        "fields": {
                                          "NAME": "unitMethod:UseSkillToTarget",
                                          "THIS": true
                                        },
                                        "id": "}aA=iLy#N8Os*vk9O8uu",
                                        "inputs": {
                                          "ARG0": {
                                            "block": {
                                              "extraState": "<mutation></mutation>",
                                              "fields": {
                                                "TYPE": "caller",
                                                "VAR": {
                                                  "id": "AE;N8eOffH#cg-r!LVHc"
                                                }
                                              },
                                              "id": "Afmj3A[a@jr@qPiZu8U^",
                                              "type": "variables_get"
                                            }
                                          }
                                        },
                                        "type": "function_call"
                                      }
                                    },
                                    "type": "function_call"
                                  }
                                },
                                "type": "function_call"
                              }
                            },
                            "ELSE": {
                              "block": {
                                "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                                "fields": {
                                  "NAME": "unitMethod:Stop",
                                  "THIS": true
                                },
                                "id": "wA!Y]KP}X1K6^}ag]MC`",
                                "next": {
                                  "block": {
                                    "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                                    "fields": {
                                      "NAME": "unitMethod:LookAtTarget",
                                      "THIS": true
                                    },
                                    "id": ".qgSN/gxWNa9dSL6X=6v",
                                    "next": {
                                      "block": {
                                        "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;}]\"></mutation>",
                                        "fields": {
                                          "NAME": "unitMethod:UseSkill",
                                          "THIS": true
                                        },
                                        "id": "!1mY@v6TL;nwfBj{oBcd",
                                        "inputs": {
                                          "ARG0": {
                                            "block": {
                                              "extraState": "<mutation></mutation>",
                                              "fields": {
                                                "TYPE": "caller",
                                                "VAR": {
                                                  "id": "AE;N8eOffH#cg-r!LVHc"
                                                }
                                              },
                                              "id": "DDVtO)T%KHmO8ieKtfB$",
                                              "type": "variables_get"
                                            }
                                          },
                                          "ARG1": {
                                            "block": {
                                              "fields": {
                                                "THIS": true,
                                                "VAR": "unitVariable:TargetPositionX"
                                              },
                                              "id": "(Iauq0vg8)E4)Po-3Xvi",
                                              "type": "variables_get_reserved"
                                            }
                                          },
                                          "ARG2": {
                                            "block": {
                                              "fields": {
                                                "THIS": true,
                                                "VAR": "unitVariable:TargetPositionY"
                                              },
                                              "id": "SFe?q0wiSmib{mcpOv83",
                                              "type": "variables_get_reserved"
                                            }
                                          }
                                        },
                                        "type": "function_call"
                                      }
                                    },
                                    "type": "function_call"
                                  }
                                },
                                "type": "function_call"
                              }
                            },
                            "IF0": {
                              "block": {
                                "fields": {
                                  "OP": "EQ"
                                },
                                "id": "4(!tcd0H|k87[*^MF+u3",
                                "inputs": {
                                  "A": {
                                    "block": {
                                      "extraState": "<mutation></mutation>",
                                      "fields": {
                                        "TYPE": "caller",
                                        "VAR": {
                                          "id": "i366AHIzFE0[@ZDZVty#"
                                        }
                                      },
                                      "id": "lx0BYI.pAYW7TQ:i%mcX",
                                      "type": "variables_get"
                                    }
                                  },
                                  "B": {
                                    "block": {
                                      "fields": {
                                        "NUM": 1
                                      },
                                      "id": "$C7K,0w8W7iIowoLhjRe",
                                      "type": "math_number"
                                    }
                                  }
                                },
                                "type": "logic_compare"
                              }
                            }
                          },
                          "next": {
                            "block": {
                              "fields": {
                                "TYPE": "caller",
                                "VAR": {
                                  "id": "Bg/9wxiGncUOClEB%%)_"
                                }
                              },
                              "id": "*GgOfyMK^w|JY=e829K2",
                              "inputs": {
                                "VALUE": {
                                  "block": {
                                    "extraState": "<mutation></mutation>",
                                    "fields": {
                                      "TYPE": "caller",
                                      "VAR": {
                                        "id": "H!6I8X[TmhHPJmxF3xes"
                                      }
                                    },
                                    "id": "-q]VS+GUP}INM3HsWp8O",
                                    "type": "variables_get"
                                  }
                                }
                              },
                              "type": "variables_set"
                            }
                          },
                          "type": "controls_if"
                        }
                      },
                      "ELSE": {
                        "block": {
                          "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                          "fields": {
                            "NAME": "unitMethod:LookAtTarget",
                            "THIS": true
                          },
                          "id": ":^w6Ni(Ama5Qq!fsQwml",
                          "type": "function_call"
                        }
                      },
                      "IF0": {
                        "block": {
                          "fields": {
                            "OP": "EQ"
                          },
                          "id": "oDnd$omDom]L)sn[(9}L",
                          "inputs": {
                            "A": {
                              "block": {
                                "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;}]\"></mutation>",
                                "fields": {
                                  "NAME": "unitMethod:GetSkillCooldown",
                                  "THIS": true
                                },
                                "id": ")Hmu-Dlml3$[l(}{Y|bB",
                                "inputs": {
                                  "ARG0": {
                                    "block": {
                                      "extraState": "<mutation></mutation>",
                                      "fields": {
                                        "TYPE": "caller",
                                        "VAR": {
                                          "id": "WlR[$(PX{83=VFHve}O;"
                                        }
                                      },
                                      "id": "71{7v)-#3sGhqwK/zlto",
                                      "type": "variables_get"
                                    }
                                  }
                                },
                                "type": "function_call_return"
                              }
                            },
                            "B": {
                              "block": {
                                "fields": {
                                  "NUM": 0
                                },
                                "id": "7?Zv$nmj`w@h-_|GjE#4",
                                "type": "math_number"
                              }
                            }
                          },
                          "type": "logic_compare"
                        }
                      }
                    },
                    "type": "controls_if"
                  }
                },
                "ELSE": {
                  "block": {
                    "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                    "fields": {
                      "NAME": "unitMethod:LookAtTarget",
                      "THIS": true
                    },
                    "id": "x89|+(x$TiZ/y0rZR(%0",
                    "next": {
                      "block": {
                        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                        "fields": {
                          "NAME": "unitMethod:Stop",
                          "THIS": true
                        },
                        "id": "Q62*Ns:H?r(Z`=!q+m[B",
                        "next": {
                          "block": {
                            "fields": {
                              "TYPE": "caller",
                              "VAR": {
                                "id": "Bg/9wxiGncUOClEB%%)_"
                              }
                            },
                            "id": "_ngO!ncZ{;)p6VtpYvNG",
                            "inputs": {
                              "DELTA": {
                                "shadow": {
                                  "fields": {
                                    "NUM": -1
                                  },
                                  "id": "#alA?F$?X.eoNBg`J+s5",
                                  "type": "math_number"
                                }
                              }
                            },
                            "type": "math_change"
                          }
                        },
                        "type": "function_call"
                      }
                    },
                    "type": "function_call"
                  }
                },
                "IF0": {
                  "block": {
                    "fields": {
                      "OP": "LTE"
                    },
                    "id": "^:b,5}X5aX[7z!,iP@tg",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "caller",
                            "VAR": {
                              "id": "Bg/9wxiGncUOClEB%%)_"
                            }
                          },
                          "id": "^PRk3Y.Qy6P`hH0,O`R,",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 0
                          },
                          "id": "+p[J+4=@/C6xvx$7PJHJ",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "logic_compare"
                  }
                }
              },
              "type": "controls_if"
            }
          },
          "ELSE": {
            "block": {
              "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:LookAtTarget",
                "THIS": true
              },
              "id": "jqDk},Aoj2$as$~^2Q,k",
              "next": {
                "block": {
                  "id": "1[#{EqG1jr%+hqUcP{uF",
                  "inputs": {
                    "DO0": {
                      "block": {
                        "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;}]\"></mutation>",
                        "fields": {
                          "NAME": "unitMethod:UseSkill",
                          "THIS": true
                        },
                        "id": "Tvu?#qkLi%ehBDdkG(|x",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "caller",
                                "VAR": {
                                  "id": "WlR[$(PX{83=VFHve}O;"
                                }
                              },
                              "id": "w9zZG3xTDx51@`Ia57[A",
                              "type": "variables_get"
                            }
                          },
                          "ARG1": {
                            "block": {
                              "fields": {
                                "THIS": true,
                                "VAR": "unitVariable:TargetPositionX"
                              },
                              "id": ",}Gb-NT!S_,|(@djh1J?",
                              "type": "variables_get_reserved"
                            }
                          },
                          "ARG2": {
                            "block": {
                              "fields": {
                                "THIS": true,
                                "VAR": "unitVariable:TargetPositionY"
                              },
                              "id": "?o^9~$#oY}%IO22xgqV$",
                              "type": "variables_get_reserved"
                            }
                          }
                        },
                        "next": {
                          "block": {
                            "fields": {
                              "TYPE": "caller",
                              "VAR": {
                                "id": "Bg/9wxiGncUOClEB%%)_"
                              }
                            },
                            "id": "DieYN;Ddh2qf.]JEe3{e",
                            "inputs": {
                              "VALUE": {
                                "block": {
                                  "extraState": "<mutation></mutation>",
                                  "fields": {
                                    "TYPE": "caller",
                                    "VAR": {
                                      "id": "H!6I8X[TmhHPJmxF3xes"
                                    }
                                  },
                                  "id": "2C(nRkrfCyyhu2UK/8o4",
                                  "type": "variables_get"
                                }
                              }
                            },
                            "type": "variables_set"
                          }
                        },
                        "type": "function_call"
                      }
                    },
                    "IF0": {
                      "block": {
                        "fields": {
                          "OP": "EQ"
                        },
                        "id": "o)s3fCRcaYg5H/2zX{m]",
                        "inputs": {
                          "A": {
                            "block": {
                              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;}]\"></mutation>",
                              "fields": {
                                "NAME": "unitMethod:GetSkillCooldown",
                                "THIS": true
                              },
                              "id": "_}diOhLj!Fru2W`bpp@T",
                              "inputs": {
                                "ARG0": {
                                  "block": {
                                    "extraState": "<mutation></mutation>",
                                    "fields": {
                                      "TYPE": "caller",
                                      "VAR": {
                                        "id": "WlR[$(PX{83=VFHve}O;"
                                      }
                                    },
                                    "id": "sPqzi[N_8)ghnXnT^%71",
                                    "type": "variables_get"
                                  }
                                }
                              },
                              "type": "function_call_return"
                            }
                          },
                          "B": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "hxo+69MRSZ]o-riJ@o{6",
                              "type": "math_number"
                            }
                          }
                        },
                        "type": "logic_compare"
                      }
                    }
                  },
                  "type": "controls_if"
                }
              },
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "LTE"
              },
              "id": "=d-Sv[49#}2x#;;?_)@f",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "unitVariable:TargetDistance"
                    },
                    "id": "v2T?%j7cGBe[MVsVT}e(",
                    "type": "variables_get_reserved"
                  }
                },
                "B": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "cyj=;nZU~+{Yi^|;t}#+"
                      }
                    },
                    "id": "2EU!)Ct%L#m)m1o!{nhq",
                    "type": "variables_get"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": 475,
        "y": 715
      },
      {
        "fields": {
          "OP": "EQ"
        },
        "id": "j4((m{pU_#b%2[MbcK|,",
        "inputs": {
          "B": {
            "block": {
              "fields": {
                "NUM": 0
              },
              "id": "A;xrDUab_$~@xtfwTOk$",
              "type": "math_number"
            }
          }
        },
        "type": "logic_compare",
        "x": 711,
        "y": 870
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Unit_Monster_Charge",
    "period": "15",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": ")rPphoqQ;#^gJU/-@`1!",
      "name": "Unit/Tick"
    },
    {
      "id": "Ofk!Q:x.#eMsU9X,t-)D",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "]0zu%je|1A@@Ln|jk-#p",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "VwmPw+Go:-Dax{ZYx^QU",
      "name": "Unit/Rome"
    },
    {
      "id": "BTB(VV*%O$b%J?C)=e!5",
      "name": "Unit/DefaultSkillID01"
    },
    {
      "id": "kPaw8dxLKsavFF1dmB:)",
      "name": "Unit/DefaultSkillID02"
    },
    {
      "id": "H|KIea5EXGTTSr3x~F;[",
      "name": "Unit/Delay"
    },
    {
      "id": "Bg/9wxiGncUOClEB%%)_",
      "name": "Unit/Time01"
    },
    {
      "id": "~|@=I`|92a85]l:bgAYV",
      "name": "Unit/Time02"
    },
    {
      "id": "H!6I8X[TmhHPJmxF3xes",
      "name": "@Unit/Delay"
    },
    {
      "id": "ne-7K^B%^}Q.c#MNIAwH",
      "name": "@Unit/Range"
    },
    {
      "id": "AE;N8eOffH#cg-r!LVHc",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "|iO3L9mW!TZ[fL`+af1v",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "C[`[x:-@.M@$jhYQDA2H",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "*UmVH#Q@H*CBv$[YuS:3",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "i2WlWF{nFP7=R1@y,E2L",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "4br6qX?AnsfM(`go[88v",
      "name": "Unit/MonsterID01"
    },
    {
      "id": ";d[W/s]xS(LLH-n$ILcX",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "26qPo*$/@RdeD|CGdVyd",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "i366AHIzFE0[@ZDZVty#",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "i7;]eh$-uFsJ]=u5{+1N",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "UWm]|FG~#B^,Ap,ohN^Z",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "G3;Nn$uyCK4[=0$%QKn^",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "Z7L2@$[f$O%3gH@%$?Ir",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "cyj=;nZU~+{Yi^|;t}#+",
      "name": "@Unit/Range01"
    },
    {
      "id": "pi%c7|MfI|53q%]Us{1T",
      "name": "@Unit/Range02"
    },
    {
      "id": ":5d?v|2i0mU94_E.{G9V",
      "name": "@Unit/Range03"
    },
    {
      "id": "MV=;2mpR:V1L,5ZGPWM^",
      "name": "@Unit/Range04"
    },
    {
      "id": "g*xvRW}5{|eL!RKRyo}f",
      "name": "@Unit/Range05"
    },
    {
      "id": "z0ROaE$_o}4a+5QDCC2y",
      "name": "@Map/MonsterID01"
    },
    {
      "id": "ZI@V!#]`(T4xJC,1MDHv",
      "name": "@Map/MonsterID02"
    },
    {
      "id": "MWw(1PYfj%Obyp7pd.?;",
      "name": "@Map/MonsterID03"
    },
    {
      "id": "ES3]1nr!wTe$cNbs!Q(v",
      "name": "@Map/MonsterID04"
    },
    {
      "id": "s7pN/#O2@*IHd~=lEw,O",
      "name": "@Map/MonsterID05"
    },
    {
      "id": "Lg*STtgUukxCvkPe/Dtc",
      "name": "유닛 컨테이너"
    },
    {
      "id": "l.yX=)+]po]4^cp2{!2H",
      "name": "Unit/AddInitBuffID"
    },
    {
      "id": "y^#(8mO?jMB{25z9=~l%",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "h${1J-bZKI1]R/Hk%Bdc",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "fJ%A-Asx9,(kCZ]ZqHM(",
      "name": "@Map/MonsterID06"
    },
    {
      "id": "R{UrgL3Plf0$`(!C}za}",
      "name": "@Map/MonsterID07"
    },
    {
      "id": "KP35Cve!@tYB=vox.,8a",
      "name": "@Map/MonsterID08"
    },
    {
      "id": "]rK_fuhJd!jy4IZk,]Cs",
      "name": "@Map/MonsterID09"
    },
    {
      "id": "[h0HwVuvnB.[ta3@#^I2",
      "name": "@Map/MonsterID10"
    },
    {
      "id": "7cJ*hVCZmVd!b^MLh^r,",
      "name": "@Map/MonsterID11"
    },
    {
      "id": "l-KF89(%$7e+e9t]HfWl",
      "name": "@Map/MonsterID12"
    },
    {
      "id": "dXQn/y;9a,tYY+-sQ[tI",
      "name": "@Map/MonsterID13"
    },
    {
      "id": "J-5pKr8r=yPxc[*ZV9wK",
      "name": "@Map/MonsterID14"
    },
    {
      "id": "gN}s1ZBN|ej_J[:K2IWt",
      "name": "@Map/MonsterID15"
    },
    {
      "id": "Aq$#md$TZT}?QP-.ndS]",
      "name": "@Map/MonsterID16"
    },
    {
      "id": ",PXm.SZ-yX]|yNtWQKXq",
      "name": "@Map/MonsterID17"
    },
    {
      "id": "v6%V-/cwze7v#]s8@%a.",
      "name": "@Map/MonsterID18"
    },
    {
      "id": "pdsTn;k!/:j$[nl]j|13",
      "name": "@Map/MonsterID19"
    },
    {
      "id": "+uQwli+xk6W2exdcNJ_(",
      "name": "@Map/MonsterID20"
    },
    {
      "id": "ORzF?[)imhu~{C51F`NQ",
      "name": "@Map/AddBuffID01"
    },
    {
      "id": "Lh1p5m#V[o!(5K|WXDS)",
      "name": "@Map/AddBuffID02"
    },
    {
      "id": "sZJb[c4hM_5Q[u!WgtuG",
      "name": "@Map/AddBuffID03"
    },
    {
      "id": "%m2S@oiHvw`qDtVqACe#",
      "name": "@Map/AddBuffID04"
    },
    {
      "id": "dq)_Nx*L,$ITX-q4?QZq",
      "name": "@Map/AddBuffID05"
    },
    {
      "id": "CMJ$9xo5L:0u2.}zRiB)",
      "name": "@Map/AddBuffID06"
    },
    {
      "id": "oDkS74(M{8T/zaD]z?^T",
      "name": "@Map/AddBuffID07"
    },
    {
      "id": "a@;Dn^eP_*P|h9%=@y~l",
      "name": "@Map/AddBuffID08"
    },
    {
      "id": "LY?S^O~wH,E%0p4q+L|5",
      "name": "@Map/AddBuffID09"
    },
    {
      "id": "lJlBD50_RottrRn]Rvc}",
      "name": "@Map/AddBuffID10"
    },
    {
      "id": "D+,nQTPiJi/_``-GD%Bb",
      "name": "@Map/AddBuffID11"
    },
    {
      "id": "=I7Ke;tujpi0S0AX:`v!",
      "name": "@Map/AddBuffID12"
    },
    {
      "id": "2xk!45)c0sSN@Ie5#.0p",
      "name": "@Map/AddBuffID13"
    },
    {
      "id": "H%21Ug[YraxyOCl^M8ZJ",
      "name": "@Map/AddBuffID14"
    },
    {
      "id": ")f(6Vsti$iBl%N(xxV?I",
      "name": "@Map/AddBuffID15"
    },
    {
      "id": "H?3pj@=Q/Pi/~9k9{SQP",
      "name": "@Map/AddBuffID16"
    },
    {
      "id": "g3#4.f;:z~qMKN~s?BBg",
      "name": "@Map/AddBuffID17"
    },
    {
      "id": "}9[orFV94},XxO,6oWo(",
      "name": "@Map/AddBuffID18"
    },
    {
      "id": "7l?x3h[2C;XRzGroX1V7",
      "name": "@Map/AddBuffID19"
    },
    {
      "id": "/i%r_./.r0NYgSZ2:1{*",
      "name": "@Map/AddBuffID20"
    },
    {
      "id": "#0V4QLGV[ELFvl%di`XH",
      "name": "Map/BattleValue"
    },
    {
      "id": "*6x`2/-7G+Zx7RKk}M}i",
      "name": "Map/IsClear"
    },
    {
      "id": "]b/Osghj~$/DWOnpp|$*",
      "name": "Map/WaveCount"
    },
    {
      "id": "|/$rR=3kqBXjYs}Z+Rb~",
      "name": "Map/WaveTick"
    },
    {
      "id": "N02`z-,oHHYf/~#iSD+*",
      "name": "Map/IsSpawn"
    },
    {
      "id": "+/HhShc7y+dee0XjfNGX",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "@j~,6Z!zUdcIE=C(jyh`",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "eLf@c;iNxwMMu2ndEH+X",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "e8PI0_n])kP#4;)m*N3X",
      "name": "@Map/MonsterID21"
    },
    {
      "id": "lGPlNJ$sn`woD_2E!.Sw",
      "name": "@Map/MonsterID22"
    },
    {
      "id": "s0m0.HoWQ)kaa=z9Nb/9",
      "name": "@Map/MonsterID23"
    },
    {
      "id": "6`D]T7[k9o*rc+~5@aiU",
      "name": "@Map/MonsterID24"
    },
    {
      "id": "Vs:^BVdtH=;dCmM+(bwU",
      "name": "@Map/MonsterID25"
    },
    {
      "id": "]~LfaG(x_.]R@`QPqjAS",
      "name": "@Map/MonsterID26"
    },
    {
      "id": "e1NN:W2;dz_Wlc~f}4s(",
      "name": "@Map/MonsterID27"
    },
    {
      "id": "12Lngs0gv8bqUl@C-A2,",
      "name": "@Map/MonsterID28"
    },
    {
      "id": "uEgKyvihnz7a;x:p#`D~",
      "name": "@Map/MonsterID29"
    },
    {
      "id": "Ur6A7ES[$/WS^+.H)g97",
      "name": "@Map/MonsterID30"
    },
    {
      "id": "};Nsb9f{hV|*MK^k3*p?",
      "name": "@Map/MonsterID31"
    },
    {
      "id": "oFe3aD`m?)0(0gYY3O30",
      "name": "@Map/MonsterID32"
    },
    {
      "id": "hGFgN(,?mH,bmt@$eJ6x",
      "name": "@Map/MonsterID33"
    },
    {
      "id": "6h}lY6B(ypa*M/SHpq$u",
      "name": "@Map/MonsterID34"
    },
    {
      "id": "0OLOs`urtKdD4%H63;zn",
      "name": "@Map/MonsterID35"
    },
    {
      "id": "{w=vNF+3rW6r`McQ9hk`",
      "name": "@Map/MonsterID36"
    },
    {
      "id": "*IdRRRJCytPr@?x-HPi*",
      "name": "@Map/MonsterID37"
    },
    {
      "id": "7B^vg1H,e$+:`9h$J?-%",
      "name": "@Map/MonsterID38"
    },
    {
      "id": "ihHY#lnnwBspy]ZENQ0=",
      "name": "@Map/MonsterID39"
    },
    {
      "id": "BTWL|JKp`3Ln}0];foq9",
      "name": "@Map/MonsterID40"
    },
    {
      "id": "TVx)$aoXHBL8^h%hL7~.",
      "name": "@Map/MonsterID41"
    },
    {
      "id": "QSZm}#k%XmUPl@z;3i:2",
      "name": "@Map/MonsterID42"
    },
    {
      "id": "N2)3@^hrxfq9t}+lL4J}",
      "name": "@Map/MonsterID43"
    },
    {
      "id": "9~kpd=M7#7Wa:oB:j!W+",
      "name": "@Map/MonsterID44"
    },
    {
      "id": "?#|29zN0{}Wkeg6gH6Zo",
      "name": "@Map/MonsterID45"
    },
    {
      "id": "l#/lQBVuW7w}%ll1#oxt",
      "name": "@Map/MonsterID46"
    },
    {
      "id": "EZ6b?`q)/(A8~3sUf:~C",
      "name": "@Map/MonsterID47"
    },
    {
      "id": "cxFwa2MJ)lmW:]4ICbUO",
      "name": "@Map/MonsterID48"
    },
    {
      "id": "YG6Yo9KxbtKVYv#;2kAM",
      "name": "@Map/MonsterID49"
    },
    {
      "id": "Vp97}TvLGck6_fVf#uCd",
      "name": "@Map/MonsterID50"
    },
    {
      "id": "hBtU;Ar@`e30eL.jpMGE",
      "name": "@Map/MonsterID51"
    },
    {
      "id": "dLp`|TfJ;Vqk)@}jNGf0",
      "name": "@Map/MonsterID52"
    },
    {
      "id": "/ZI_-l5tQ.=1NqSRgbNV",
      "name": "@Map/MonsterID53"
    },
    {
      "id": "Nfhz#;@+W^^4Oo`^o*u1",
      "name": "@Map/MonsterID54"
    },
    {
      "id": "$oe|xdpmOhj/|GtKS*:2",
      "name": "@Map/MonsterID55"
    },
    {
      "id": "|mkdMastz5bGob1mFa|5",
      "name": "@Map/MonsterID56"
    },
    {
      "id": "r?HeP=SA%($^*|WXtVsX",
      "name": "@Map/MonsterID57"
    },
    {
      "id": "7VNU|R48ZE@#!0I^`Lj$",
      "name": "@Map/MonsterID58"
    },
    {
      "id": "?U=d!J=0~1T0y]x)JnGu",
      "name": "@Map/MonsterID59"
    },
    {
      "id": "t}icU,OAnX^cN7D0DA3e",
      "name": "@Map/MonsterID60"
    },
    {
      "id": "AE`O|$%UDJBH9U8q$Qk0",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "1/cF*1^lGEwf,IFI3JQA",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "#WgN8HIv-%_[x``Gw=0;",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "08.Akhbm)pObu#$%vCPG",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "bG-^wMV8e5%D_]?$pp-3",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "t878BpK.Gwad5_.K%i#7",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "F7[mc!J0c^m4Cto;.M/Z",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "dcDySwsh2DmaLq[Nqgbw",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "BVbn8I:#CJZ4{;@^g{ds",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "=A6E}irq8eE=s@QP(1QE",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "D2?|D[wP[YuO=[G_fsnb",
      "name": "@Buff/Variable/01"
    },
    {
      "id": ",{J=`aaUhMM/.L,(MXeV",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "#n{%C#7W_K~kyh~e/#nU",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "0WQq|BrgfzK}Yqg7^Ki@",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "x6vc$4|0}{N5JF/FQSEU",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "s{Uxm6MP71@s6?~ywh7y",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "TqqVdnwio?tI3neqUk(=",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "*;gs_u?TtVi+-i3xCBWw",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "00ZurEP~Yh`n2;0Ac@2s",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "blf4v+*{MAD3|wGMgZeY",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "V@N8%;e?n?z2F~v[RpC0",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "ouF=X0~3KazASpPT9=Wy",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "ovKxrf8()pNnNZ(Rfsj`",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "N!0:RdS{s{%t*KY?*N7.",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "f/8|w6z5g=~Qv1+M-K;o",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "4z|_WrMw)vgs?p[p%$!(",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "F}A1R)@HI)d}Gf!f`]v9",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "U;`fsI1^ZxT/4Xqu6Ax5",
      "name": "@Map/Variable01"
    },
    {
      "id": "X/Fi4IA92=Bny?*kV^mZ",
      "name": "@Map/Variable02"
    },
    {
      "id": "u_w4HdHON@UEg3NRZbtY",
      "name": "@Map/Variable03"
    },
    {
      "id": "v(M?*WUA55#y=8yXrDDL",
      "name": "@Map/Variable04"
    },
    {
      "id": ",_8}c{-#b3lH*jhjUF/W",
      "name": "@Map/Variable05"
    },
    {
      "id": "r/*+8lG*~Vsw8=}dR%}-",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "6b$;m*Wy1OkqTH[3h~y{",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "Q|s]+HR1EuV?,#/X#s{]",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "?u`(Z_+h#Gs#}GMc3gK%",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "r8;ZvX(?dMS4gH_C=VjD",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "#)Q=cKwom+5|ce7a~L,[",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "~)K_:w8f8fc_@7;4X{1o",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "eYXey*:5)nv03j!VZ=N[",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "PAR]PRq|yOV@{L6xtbZT",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": "yxGJO`_It)9b#08/Pu(S",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": ".gqai5hPD%;:ny;)P!bO",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "H/OWsd}tk~oWNC{k[W[X",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "z0~G=h0|tKftl8|FA;?1",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "nCscq;~xa01Z(R[SI-gE",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "@TonZN6!%P:`]|bKt;*M",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "F5$+o?^Wz,dt)]YL1(x]",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "r(M|IW6bNy,FWw7}).=z",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "NF-vx`c_={+~-$e/lUw{",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "i}I1?._DG4u?9%Z$N6/y",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "OXQy/k4FS^6baZD_Z99b",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "h}XfcMAS[d_bv_UD!$#)",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "gfb,TPJPsK*,`h#Z[C-[",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "9tHhZF]U@YHm|SNKij}U",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "/iL=GN,XX9[/y29%a;}R",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "PgLSY*l(c!H10EV]TUoN",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "n~5mFStFO.vTJ0Toy3@X",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "S5%^:2/*FFaapB;$I(07",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "~]|sI-0TZF4gZ;`09Qn|",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "|pHF!(R`f-4Lu}jFSu$h",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "4e?Y%Q?@D*GnRn4t:X}F",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "q^pt8IzXH*+PN/LLQX[i",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "I2+#!eChg5wf/bbM6H!)",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": ":@B.sXNAYs:1n}5mD9bp",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "U31P?y#I?x4:|fV/Y~hr",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "icR`slZ_M6aL?I_V(0mk",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "sLeM%*y+n?5o-o9R4u_V",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "`pPNjjX/@SNU9E]:N#GQ",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "Oz)=G~Iy[b4Zr0,O4h;l",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "6x?v+~AGyNd*QRR~r%d/",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "ZDwfyU[S+N!.ed*A)QGB",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "=o_-0AoF_,8unY,pzql1",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "Z`JlR@.8n:0=CT966-tp",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "4qtVhlNc.3#muC8zYY,1",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "o%G;6Xk-~xz)|uRHfK%=",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "_$mcIg8Dy5%iSeIb/+zB",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "y+{1b:wdGQmM~TWlMr1|",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "FxSd!|ZS*Qky4^1__JbW",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "CX[|3;%cYW4Z!x0!AVE3",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "U%MN+Or8;lOR#t,?H0Ed",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "Qwk~4XKBrCy5GfKub6m=",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "dlw=1_)2|mbqLYhi9p:D",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "#-tlbaaH2Hm`nLmO@;,L",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "hjg/pQJVfZphBP-#p75]",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "6*y=D~nzECFR!5A/5L9s",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "]jTH$,bmNTTG}B(LYn_j",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "nKIUNCEVrT:Bdf?:9I$G",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "fcw^?bnbg#0Enl|$diNV",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "Q?enAvrlo+j6+tSF.Dru",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "zitDH6`Z~4yd(rLpY7t]",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "iIL4La+,s/$%y#aX3Nfe",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "bGcor0+D.q[O[~0NY]|O",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "AU7T3ZIjY5]]^-aWrBS$",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "R#nh9raty9sBK@*o{C/1",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "bv/P`IWc?KfJ0a_c]s`D",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "^#ebtXXUTVW#h*D$=o[=",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "PuJ:=L8^[=zdjz^wK[xJ",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "cB{6)PjMd`[d:J|JrZ1V",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "gr|(exGIh=cJj1XD-*tV",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "8ua?Ly=*f9*}Ait%ACeJ",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "M3`$_{$45v3up;?HA1o1",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": ":2nL78WA6@OVFYAPr}|@",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "(CWBg:bJ(#HDZPdFv{8Q",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "gd{m[Ax+t@?^.Wwe^l-s",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "[i$,hL{KRup3Matfml9N",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "yr5Fc9Eg`3f5u,@2+wva",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "`uhzab%)Bwcrl}~c3ijU",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "lF:h*c5tF;{.@`Z*T0)E",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "KKe@7HO6;JhFOZT`YHm@",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "kJqLq$e@%yrgk_fY%k;c",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "aP4w6:E.*gB`Ss-_}yVi",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "p)fD^8D:HD}i^d3N2NF_",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "1rr@hDbBjThJ6ok][,-o",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "NwD}ijU+`^r1|HHt03[,",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "U(r(*Y0i75]rC,vb-hcy",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "#L[]n8K)#o)YT6fO|t-F",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "A;1*`BxiR@HCf^CJu%z7",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "aTZ2~*?*r,ii!3$~zrFO",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "zP[DTcI_THXo^CIu~EzE",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "],4e9L)BxBsC6T+RT04o",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "4sWRPM23uRV%{~{#8k6y",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "6F?AASK7!F.k^5~F._ot",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "?:b6^*UQ3HOu.2QL?YH2",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "119:;t.9T0-nu12av|/#",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "n3aJi#KO7F.3BthoD$r+",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "K?n}oyJ0u|-5hnbHdDI0",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "0~Cb~Kh[Q|(2|syHQ9G?",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": ";VxX*Pwut+s#5CeJ/$~O",
      "name": "@Unit/Variable01"
    },
    {
      "id": "Cxxx9+.Ls,HrG5O_k1|-",
      "name": "@Unit/Variable02"
    },
    {
      "id": "tFFX=oK]pm6Kr59!omc`",
      "name": "@Unit/Variable03"
    },
    {
      "id": "9JKB`W2E8%30Uy#UoT5:",
      "name": "@Unit/Variable04"
    },
    {
      "id": "%Ha)Wu/e*nVT-QlNod-l",
      "name": "@Unit/Variable05"
    },
    {
      "id": "cZP1HUW%e.AKY4e6HFT-",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "p~NpZlAJ#RyTX-s_j!*q",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "gjN7x`x8Q!;@1{S4HRii",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "(xN?I3UUw(_J(]O.#(72",
      "name": "@Skill/Trait/BlastIncreaseKBPercent"
    },
    {
      "id": ";x1XVDbHnLg^/2Qr);Zw",
      "name": "Gem shops"
    },
    {
      "id": "Eq]`UeYDEH}PNA^un+$4",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "R$s9eAzZ{W0z]IL/T$K|",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "tW1ZZphp.C6d$YS#fs3X",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "V|}zdVQ1[F1SXYJLOd:8",
      "name": "Map/Wave"
    },
    {
      "id": ",dX{4{zt3KDO#G@1+z^M",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "C!a@0T6Bww6le(gRy.6.",
      "name": "Map/Wave/Step"
    },
    {
      "id": "E(2q[:x}}aHLqiEHNShc",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "d4QkA#Nx5#~3g#XV*XEd",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "%l-q_r(DjQ,tR6VrT=c@",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "iw_T*1A-vY[Xczp+VGXf",
      "name": "Map/Wave/State"
    },
    {
      "id": "4]?iU=8~?;i]mM0IZ$X1",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "gRH{Ewg2`rB?0H)YjaE)",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "QM``Gbb+~L]z:Pt:3X~v",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "-DG.Wl0IC2WDj9O/w|~V",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "yhl^)!4TMEy-x,PH9tuy",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "ac.TB#6MegsgI2SwW)Op",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "j-6-RJ@1`ylyDi3(utdd",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "{tk,L:TVGtKZ**.]e_s/",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "uENS?HBs5t5K[,yL2+v*",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "0we1GraK5cnYT$!8~#ma",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "*=XNo)Y%pZepGg(8{E,,",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "(1H~t*E}(vS64HZP_3HJ",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "QYt?#JUVpYOo@c|6!5B4",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "s`Ss:4=Is]:cOpng4S2s",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "`V4h1PmL:]%x$+@y44XP",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": ";%|D9IkiV|IXdB=vYy;P",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "va`Nz9y)m3)y)9If^,aO",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "b?rL(6UatS4bHR)3-V6^",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "{ivg{mw2L.mfcH*4k|lr",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": ")!M7;d`IozBI%]@K#Y_C",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "#OY{e{EUg[1}$5b)VXLp",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "Kj#I1Rf#To_4DD3QX=,*",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "*qaPzmUZK**6F8;R(K*~",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "NeCBDCd.^Jo{$g*$ua`s",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "1m7B-TZozyr+y[K|*YYd",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "VR+^=f$~M;LS[q#vtjW{",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "f3=YgZdulWp3PENd^=n%",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "1Si6ytrhrM=R~nBf,N=e",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "w1k|,HkCCi{UjlRsbUjk",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "kz^cugy|wR~dxv:G=Ig[",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "lcr$jNXLJBP)3e@8L+,k",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "[DogUp-q-Z9A{2]|cj[q",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "p.~dljQjazLoCDxW;/0@",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "Kr#.!V^$IdCYg3d3=oIY",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "?)OqD*Ti(qT|e3wv4sH]",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "J(o~]?3?21fr:%*4H$V;",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "LnjO@F1`d7/)Bt}/ZEuv",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "SND;JoRH^Sfb^[?/m9KP",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "p,@gK*.B5[tIF5[uUA+j",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "kGAU8K}gad5kq_ol#tMm",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "-t%|{U0.l?V$YnrHh+lT",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "7P4Ta`/,P%1i!d;Gneee",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "I9Ty;DF^isi7+r}_|0O+",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "?n*3TX/r95r(LjTjEdA6",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": ".m~nYp!zT1M%Su-bj~zj",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "9v@[S(q3|i31f9JouPQ!",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "}vVNa@HS[i+g@,WgWy0-",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "4h38gD7;,r{Fm;td-O|I",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "0//jv?bYGf~N9Ioa:0q)",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "O.@9L%2$M.T}[-)kqm/w",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "/|w);19f}`P,eu/tN1MP",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "sN`a0_icMhB(Za3ymi#e",
      "name": "Gem"
    },
    {
      "id": "[m.DF2B9fPuf=XfZdLGJ",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "0jDRSUkRi%sR,PmQXh[k",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "v{1^}hH0q*C]*+LV`$f~",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "[Ew[?{%vP=$7@pwH70[}",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "WlR[$(PX{83=VFHve}O;",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": ";T}3~xTJ.WvGNR62ZQ2h",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "wvD*}w)I(?_:KUOU`bKM",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "KnGNq$dx^*II;JtL#KfG",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}