{
  "blocks": {
    "blocks": [
      {
        "id": "5/GO$rM[%(f+AVAc9|c0",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"5\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;DirectionX (default = unit X)&quot;,&quot;name&quot;:&quot;DirectionX&quot;},{&quot;comment&quot;:&quot;DirectionY (default = unit Y)&quot;,&quot;name&quot;:&quot;DirectionY&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:UseSkill",
                "THIS": true
              },
              "id": "_.q!lE4$;WCaYUdL[zFK",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 100001
                    },
                    "id": "c4*x]]:Fg5k}GuOc+;`9",
                    "type": "math_number"
                  }
                },
                "ARG1": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "skillVariable:PositionX"
                    },
                    "id": "]XpS;IG#S+-(k{E%77o#",
                    "type": "variables_get_reserved"
                  }
                },
                "ARG2": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "skillVariable:PositionY"
                    },
                    "id": "RmH2o8t:Y_WV^6W@lP2@",
                    "type": "variables_get_reserved"
                  }
                }
              },
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "extraState": "<mutation></mutation>",
              "fields": {
                "TYPE": "caller",
                "VAR": {
                  "id": ");SahaBQ8F|w#~lA4mVo"
                }
              },
              "id": "nksY_Cmp}BamIf;Vl9kG",
              "type": "variables_get"
            }
          }
        },
        "type": "controls_if",
        "x": -655,
        "y": -875
      },
      {
        "fields": {
          "TEXT": "저주 관련"
        },
        "id": "*~]aCFBjl$]M3Ksoj_S,",
        "type": "text",
        "x": -645,
        "y": -625
      },
      {
        "id": "!FuJ{fBD5kFyhszvW$F)",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;slot유닛 여부(1=slot)&quot;,&quot;name&quot;:&quot;Value&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:GetBuffByDataId",
                "THIS": true
              },
              "id": "iKWG92d0_wyT@xNOAlbr",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3115041
                    },
                    "id": "S}/@OK}X)n#*6=Pe-J_C",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "THIS": false,
                    "VAR": "buffVariable:Level"
                  },
                  "id": "Ka||Uq:p}lqAwcb)Ghpq",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "NUM": 1
                        },
                        "id": "e0Y7RLniYjPzJud7{X]r",
                        "type": "math_number"
                      }
                    }
                  },
                  "type": "variables_set_reserved"
                }
              },
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:IsBuffApplied",
                "THIS": true
              },
              "id": "-)HFyfMgRrY$m`~_t$=J",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3115041
                    },
                    "id": "^tO0rFK*m?-bw19o6cf]",
                    "type": "math_number"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -685,
        "y": 925
      },
      {
        "fields": {
          "TEXT": "피해를 받은 후 다음 공격의 치명타 확률 +25% level줄여주기"
        },
        "id": "_hXNnws%5ZE:gg?QOhHC",
        "type": "text",
        "x": -695,
        "y": 865
      },
      {
        "id": "lZIWYRT_{,drP1|yHh1}",
        "inputs": {
          "DO0": {
            "block": {
              "id": "o[4kd9){}D-3?fK9tc?p",
              "inputs": {
                "DO0": {
                  "block": {
                    "id": "KOCjK.YAarM2.t)YBj-h",
                    "inputs": {
                      "DO0": {
                        "block": {
                          "extraState": "<mutation itemCount=\"5\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;DirectionX (default = unit X)&quot;,&quot;name&quot;:&quot;DirectionX&quot;},{&quot;comment&quot;:&quot;DirectionY (default = unit Y)&quot;,&quot;name&quot;:&quot;DirectionY&quot;}]\"></mutation>",
                          "fields": {
                            "NAME": "unitMethod:UseSkill",
                            "THIS": true
                          },
                          "id": "j%w,Xvmg#H;l3krW/#0%",
                          "inputs": {
                            "ARG0": {
                              "block": {
                                "fields": {
                                  "NUM": 50501
                                },
                                "id": "Yzd?J69l{Jv4_LX=*LKH",
                                "type": "math_number"
                              }
                            }
                          },
                          "type": "function_call"
                        }
                      },
                      "IF0": {
                        "block": {
                          "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                          "fields": {
                            "VAR": "IsCritical"
                          },
                          "id": ",sIAE0Y_Nn36?C`z.mJT",
                          "type": "variables_predefined_get"
                        }
                      }
                    },
                    "type": "controls_if"
                  }
                },
                "IF0": {
                  "block": {
                    "fields": {
                      "OP": "GTE"
                    },
                    "id": "[P;gl)C_[vsVRPwrO;(P",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "NUM": 30
                          },
                          "id": "D!*2x[]9j;,9LGPcc,lV",
                          "type": "math_number"
                        }
                      },
                      "B": {
                        "block": {
                          "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;최솟값 [이상] (필수)&quot;,&quot;name&quot;:&quot;Min&quot;},{&quot;comment&quot;:&quot;최댓값 [이하] (필수)&quot;,&quot;name&quot;:&quot;Max&quot;}]\"></mutation>",
                          "fields": {
                            "NAME": "boardMethod:RandomIntBetween",
                            "THIS": false
                          },
                          "id": "WM{`ciKJ{g-DcQ%s:XXR",
                          "inputs": {
                            "ARG0": {
                              "block": {
                                "fields": {
                                  "NUM": 0
                                },
                                "id": "O.3%3tPb5[q#dFC.e*z^",
                                "type": "math_number"
                              }
                            },
                            "ARG1": {
                              "block": {
                                "fields": {
                                  "NUM": 100
                                },
                                "id": "7XVLL}q^B]ybbq:EB=w;",
                                "type": "math_number"
                              }
                            }
                          },
                          "type": "function_call_return"
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
          "IF0": {
            "block": {
              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:IsBuffApplied",
                "THIS": true
              },
              "id": "11ETTiLC)=So|nfr=DQ6",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3314011
                    },
                    "id": "ZX/Ki_J-fghe?S)f0~pI",
                    "type": "math_number"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -685,
        "y": 1465
      },
      {
        "fields": {
          "TEXT": "\"7번의 공격마다 가까운 적에게 신성 발동 -3325011"
        },
        "id": "=t1Hojz~E,Fd]9/=PSe^",
        "type": "text",
        "x": -685,
        "y": 2235
      },
      {
        "id": "$c}#6gU}r^%aAzm;Wc@y",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;slot유닛 여부(1=slot)&quot;,&quot;name&quot;:&quot;Value&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:GetBuffByDataId",
                "THIS": true
              },
              "id": "Bk+a=y8/IZ9tb}GG{;61",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3325011
                    },
                    "id": "C@EiTZ.{/1#kGMjMF;4I",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                  "fields": {
                    "NAME": "buffMethod:IncreaseStack",
                    "THIS": false
                  },
                  "id": "l9|A9,z7/^^e^sT1ttVv",
                  "type": "function_call"
                }
              },
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:IsBuffApplied",
                "THIS": true
              },
              "id": "ovN`T@h1Vatg8U4{B0a%",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3325011
                    },
                    "id": "BwdNwf:L{jf2Uo*FMw{N",
                    "type": "math_number"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -695,
        "y": 2295
      },
      {
        "fields": {
          "TEXT": "\"4번의 공격마다 가까운 적에게 신성 발동 -3325011"
        },
        "id": "AM6:I]xvgA@:u:`^`n#f",
        "type": "text",
        "x": -705,
        "y": 2515
      },
      {
        "id": "u3Ouqh{6zRRyktOp6#~N",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;slot유닛 여부(1=slot)&quot;,&quot;name&quot;:&quot;Value&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:GetBuffByDataId",
                "THIS": true
              },
              "id": "m_1`/dtHn)Z[nHbgilri",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3326011
                    },
                    "id": "(Z@P}6KxB^[9Xq9=k=0q",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                  "fields": {
                    "NAME": "buffMethod:IncreaseStack",
                    "THIS": false
                  },
                  "id": "1c-0J]jaG:ka-aPjZ`Q8",
                  "type": "function_call"
                }
              },
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:IsBuffApplied",
                "THIS": true
              },
              "id": "aF~sU=VeLwOj$1Gj[7!Q",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3326011
                    },
                    "id": "^|Vo5Iyi8RKzg(k%lL)F",
                    "type": "math_number"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -695,
        "y": 2585
      },
      {
        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
        "fields": {
          "VAR": "Return"
        },
        "id": "6`;bJLVS)o-J~g,w|*)n",
        "inputs": {
          "VALUE": {
            "block": {
              "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
              "fields": {
                "VAR": "Damage"
              },
              "id": "AoprcT:eM(*x,E48KI?x",
              "type": "variables_predefined_get"
            }
          }
        },
        "type": "variables_predefined_set",
        "x": -685,
        "y": 3615
      },
      {
        "fields": {
          "TEXT": "\"치명타 발동 시 체력이 가장 높은 적에게 검-확률(3314011)"
        },
        "id": "wBQL@?bX+sQgW-w#$q%Z",
        "type": "text",
        "x": -695,
        "y": 1425
      },
      {
        "fields": {
          "TEXT": "피해를 받은 후 다음 공격의 공격력 45% level줄여주기"
        },
        "id": "tu%#1;Wr)s,`?(|L9REX",
        "type": "text",
        "x": -675,
        "y": 1145
      },
      {
        "id": "m:CT=~agu-5%%f6E(%!Q",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;slot유닛 여부(1=slot)&quot;,&quot;name&quot;:&quot;Value&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:GetBuffByDataId",
                "THIS": true
              },
              "id": "TxK)U8i33R?=|UU-s#oF",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3315041
                    },
                    "id": "I@IlCzwNjwOl0!TFsvL|",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "THIS": false,
                    "VAR": "buffVariable:Level"
                  },
                  "id": "?z/*F`UT8@I$,YxIe%dx",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "NUM": 1
                        },
                        "id": "Suv_DyycD{84|,Zm=OuP",
                        "type": "math_number"
                      }
                    }
                  },
                  "type": "variables_set_reserved"
                }
              },
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:IsBuffApplied",
                "THIS": true
              },
              "id": "t8hr1i$p+-p7ozeo$kID",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3315041
                    },
                    "id": "kuxBLfC5bS{i@kmzyklp",
                    "type": "math_number"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -685,
        "y": 1195
      },
      {
        "fields": {
          "TEXT": "\"피해를 받은 후 다음 공격 시 최대 체력의 5% 회복 \" - 3515042"
        },
        "id": "`,S;oLX#BnGLs-.UykNj",
        "type": "text",
        "x": -705,
        "y": 3125
      },
      {
        "id": "@Y`XT@!8:h`z9PAk8HVg",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:AddBuff",
                "THIS": true
              },
              "id": "79+gMZc@3MOfMv)**rKd",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3515043
                    },
                    "id": "c,TAOdi^*zK/v`Y2x}5V",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "unitMethod:RemoveBuff",
                    "THIS": true
                  },
                  "id": ")=5#3mwBYakm*t{a9jp-",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "NUM": 3515042
                        },
                        "id": "!~%^-h5MG@O=+2CKkF`I",
                        "type": "math_number"
                      }
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
              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:IsBuffApplied",
                "THIS": true
              },
              "id": "jq9[,9d;l$g^3zalRU%4",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3515042
                    },
                    "id": "nOnJ]e6:#v}Lj=`I:Xv=",
                    "type": "math_number"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -695,
        "y": 3205
      },
      {
        "id": "(VnoLrM%3C[iAEDjIQWI",
        "inputs": {
          "DO0": {
            "block": {
              "id": "sel2#(gAW9@_!+NMYC]3",
              "inputs": {
                "DO0": {
                  "block": {
                    "extraState": "<mutation itemCount=\"5\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;DirectionX (default = unit X)&quot;,&quot;name&quot;:&quot;DirectionX&quot;},{&quot;comment&quot;:&quot;DirectionY (default = unit Y)&quot;,&quot;name&quot;:&quot;DirectionY&quot;}]\"></mutation>",
                    "fields": {
                      "NAME": "unitMethod:UseSkill",
                      "THIS": true
                    },
                    "id": "p!$=D~-$m0rpKMXcX^TS",
                    "inputs": {
                      "ARG0": {
                        "block": {
                          "fields": {
                            "NUM": 50501
                          },
                          "id": "H~fVGhK!TYy4:=pkgdVv",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "function_call"
                  }
                },
                "IF0": {
                  "block": {
                    "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                    "fields": {
                      "VAR": "IsCritical"
                    },
                    "id": "0zNb(a4tI#$Q?lr=R-J8",
                    "type": "variables_predefined_get"
                  }
                }
              },
              "type": "controls_if"
            }
          },
          "IF0": {
            "block": {
              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:IsBuffApplied",
                "THIS": true
              },
              "id": "z`L_]Je%#W2(T78cWka_",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3315011
                    },
                    "id": "1i#BOUdm^EK0PcQW3g*?",
                    "type": "math_number"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -685,
        "y": 1915
      },
      {
        "fields": {
          "TEXT": "\"치명타 발동 시 체력이 가장 높은 적에게 검(3315011)"
        },
        "id": "zUfz{yxDNG:@lAe+-J[(",
        "type": "text",
        "x": -685,
        "y": 1885
      },
      {
        "id": "|:5ihcEK2h01AQEm;(t|",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;slot유닛 여부(1=slot)&quot;,&quot;name&quot;:&quot;Value&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:GetBuffByDataId",
                "THIS": true
              },
              "id": "N#vtx#U|!*LO|!@f%EfT",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3316021
                    },
                    "id": "bF6gj}sz4VTbGB`xXK]*",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                  "fields": {
                    "NAME": "buffMethod:IncreaseStack",
                    "THIS": false
                  },
                  "id": "U3J,}hprgOs{SfJh?0hi",
                  "next": {
                    "block": {
                      "id": "]HJNl0HZKCLi0Wv7$;03",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "unitMethod:AddBuff",
                              "THIS": false
                            },
                            "id": "VAHY2YZQ:8Ug=iD-l;7H",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "fields": {
                                    "NUM": 50300
                                  },
                                  "id": "X_StL,Yvoa,av19QfLXN",
                                  "type": "math_number"
                                }
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
                            "id": "uZ)*=bH!DTKU|8LyA(j*",
                            "inputs": {
                              "A": {
                                "block": {
                                  "fields": {
                                    "THIS": false,
                                    "VAR": "buffVariable:MaxStack"
                                  },
                                  "id": "ve.eC?cCC}7{sdH:ICAt",
                                  "type": "variables_get_reserved"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "OP": "ADD"
                                  },
                                  "id": "cOehQMSBHAud5eQAVx(x",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "fields": {
                                          "THIS": false,
                                          "VAR": "buffVariable:Stack"
                                        },
                                        "id": "fg;(/FDVCTG1[gcuVNY*",
                                        "type": "variables_get_reserved"
                                      },
                                      "shadow": {
                                        "fields": {
                                          "NUM": 1
                                        },
                                        "id": "HwvB~-|g(zyD/#s7#g?i",
                                        "type": "math_number"
                                      }
                                    },
                                    "B": {
                                      "shadow": {
                                        "fields": {
                                          "NUM": 1
                                        },
                                        "id": "Z9Iw+J?K=@EWGjR.r_FK",
                                        "type": "math_number"
                                      }
                                    }
                                  },
                                  "type": "math_arithmetic"
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
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:IsBuffApplied",
                "THIS": true
              },
              "id": "4[Ml:mC/R(xP6qj)a?/~",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3316021
                    },
                    "id": "88rw5p,$(ijZ?}`l=ub]",
                    "type": "math_number"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -655,
        "y": 365
      },
      {
        "id": "=+8FW|;vv(GynXUy3`7n",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;slot유닛 여부(1=slot)&quot;,&quot;name&quot;:&quot;Value&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:GetBuffByDataId",
                "THIS": true
              },
              "id": "F9@3Qnm]Zc7)Zys;J+@I",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3314021
                    },
                    "id": "fv`pN.GzXx_@XfP)`.Kf",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                  "fields": {
                    "NAME": "buffMethod:IncreaseStack",
                    "THIS": false
                  },
                  "id": "FR%,@DWm$4H(`T}lvH72",
                  "next": {
                    "block": {
                      "id": "O1j,u3*E0]C=cMrsBmZF",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "unitMethod:AddBuff",
                              "THIS": false
                            },
                            "id": "]r;:h5V0(`]He~2yRhf2",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "fields": {
                                    "NUM": 50300
                                  },
                                  "id": "i7/~T;L{Xybdk7~K^-Zk",
                                  "type": "math_number"
                                }
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
                            "id": "`v|FYedjGSng,u?+pFWc",
                            "inputs": {
                              "A": {
                                "block": {
                                  "fields": {
                                    "THIS": false,
                                    "VAR": "buffVariable:MaxStack"
                                  },
                                  "id": "E~RHFR=!zrD%Q4Ih0n2;",
                                  "type": "variables_get_reserved"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "OP": "ADD"
                                  },
                                  "id": "Qz__tMfLv]I_m:!CqLJy",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "fields": {
                                          "THIS": false,
                                          "VAR": "buffVariable:Stack"
                                        },
                                        "id": "zAYpF%#oe*T`cDl9MYI_",
                                        "type": "variables_get_reserved"
                                      },
                                      "shadow": {
                                        "fields": {
                                          "NUM": 1
                                        },
                                        "id": "HwvB~-|g(zyD/#s7#g?i",
                                        "type": "math_number"
                                      }
                                    },
                                    "B": {
                                      "shadow": {
                                        "fields": {
                                          "NUM": 1
                                        },
                                        "id": "33rwGrs7ND9,Ak43Vv*s",
                                        "type": "math_number"
                                      }
                                    }
                                  },
                                  "type": "math_arithmetic"
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
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:IsBuffApplied",
                "THIS": true
              },
              "id": "GO{LO%o+cmmM3~pYt%%%",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3314021
                    },
                    "id": "Nf}zZq8nXt#[QO]@whOP",
                    "type": "math_number"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -655,
        "y": -585
      },
      {
        "id": "OX^TI,@==^VM0dMM{.wL",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;slot유닛 여부(1=slot)&quot;,&quot;name&quot;:&quot;Value&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:GetBuffByDataId",
                "THIS": true
              },
              "id": "sGnrENUg;]0aHod%xi_.",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3315021
                    },
                    "id": "7v99;0p]*HYUX=XwXKN*",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                  "fields": {
                    "NAME": "buffMethod:IncreaseStack",
                    "THIS": false
                  },
                  "id": "B`^szIuw~biqsy-8NW@Y",
                  "next": {
                    "block": {
                      "id": "I]F7:JP)Mvc9|2[Rz6YF",
                      "inputs": {
                        "DO0": {
                          "block": {
                            "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                            "fields": {
                              "NAME": "unitMethod:AddBuff",
                              "THIS": false
                            },
                            "id": "V/W,I2L7/T~:bQzTO;S^",
                            "inputs": {
                              "ARG0": {
                                "block": {
                                  "fields": {
                                    "NUM": 50300
                                  },
                                  "id": ":,eJ=Es~qsmGG)S6|kl}",
                                  "type": "math_number"
                                }
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
                            "id": "06@toxV(0)|[WE[BEe*S",
                            "inputs": {
                              "A": {
                                "block": {
                                  "fields": {
                                    "THIS": false,
                                    "VAR": "buffVariable:MaxStack"
                                  },
                                  "id": "IKA|vI,r9qq)1w+Q+;$|",
                                  "type": "variables_get_reserved"
                                }
                              },
                              "B": {
                                "block": {
                                  "fields": {
                                    "OP": "ADD"
                                  },
                                  "id": "Pjz~c3*5q4egMK}MR!7e",
                                  "inputs": {
                                    "A": {
                                      "block": {
                                        "fields": {
                                          "THIS": false,
                                          "VAR": "buffVariable:Stack"
                                        },
                                        "id": "I,=5pUDTnd7sy8DcQ4MZ",
                                        "type": "variables_get_reserved"
                                      },
                                      "shadow": {
                                        "fields": {
                                          "NUM": 1
                                        },
                                        "id": "HwvB~-|g(zyD/#s7#g?i",
                                        "type": "math_number"
                                      }
                                    },
                                    "B": {
                                      "shadow": {
                                        "fields": {
                                          "NUM": 1
                                        },
                                        "id": "ejxZOe1BNXBiO5ykUzv]",
                                        "type": "math_number"
                                      }
                                    }
                                  },
                                  "type": "math_arithmetic"
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
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:IsBuffApplied",
                "THIS": true
              },
              "id": "@K2qyPFJ[F4/xsAAl)uj",
              "inputs": {
                "ARG0": {
                  "block": {
                    "fields": {
                      "NUM": 3315021
                    },
                    "id": "3LQN[DbxMts?$jfmb5v(",
                    "type": "math_number"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -630,
        "y": -121
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_InventorySkillDefault_Attack",
    "period": "0",
    "triggerType": "2"
  },
  "scroll": {},
  "variables": [
    {
      "id": "!-]nt6$a6is0}O~YVgwX",
      "name": "Map/IsInitVariables"
    },
    {
      "id": ",0=:fzJ~|}Xhf_X}igj6",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "zvkF!pg-oC2bYAj5oqp1",
      "name": "Unit/Time01"
    },
    {
      "id": "q8UUU9VV1.|A{KJd|?5,",
      "name": "Unit/Time02"
    },
    {
      "id": "ETp9/B[*KqSNj7(Fe5;z",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "VGejr)b|8Gfl(RLkW-nc",
      "name": "Unit/MonsterID02"
    },
    {
      "id": ":]#[c:CYLIyP+ajc=3;d",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "ebIHt-[!@`1:VG3Vwq.o",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "X[9[hdmByVHK:]h.HJvW",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "-f1/B=hZ|1Q%Aq6FbLZi",
      "name": "Unit/Tick"
    },
    {
      "id": "NqB3.8gqn@Q]ElPP(@HK",
      "name": "Unit/Rome"
    },
    {
      "id": "xF/F!?t$d3V5%jA}qMuc",
      "name": "@Unit/Delay"
    },
    {
      "id": "sMR%O[2lUqvCe@L`SLCi",
      "name": "@Unit/Range01"
    },
    {
      "id": "S0A2qo#CQ$W_~IG[mQ~@",
      "name": "@Unit/Range02"
    },
    {
      "id": "5Vj!l|+p#pcNxk(:+1le",
      "name": "@Unit/Range03"
    },
    {
      "id": "-x}b=FES(D,y?1ZWz]ny",
      "name": "@Unit/Range04"
    },
    {
      "id": "7!$8Y*oa],Epbh1sMddQ",
      "name": "@Unit/Range05"
    },
    {
      "id": "Cui|_[g294f}S_wZE+O}",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "-:g(h.=G41NNQ:.0Fzi7",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "=*5eFDs4GQ)0mjl*Sz2`",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "Kv!;@P_XARINp[od)9oi",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": ")EOp3)yv==cSvZDbK?0I",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "FtR99l;Z*xM[Y|}(Dw9d",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "dpV;=|YIm7gplDG)vfN%",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": ":JrJqOQtm=/ES{M_{[J+",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "f{N22SDu=J%v:w:Ch2_)",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "+==O64wb_L#K:F#I!8BK",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "%UlWHbI#pJqf*v%A9#/P",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "-4reVm?F_/Ckrw~CSXR,",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "fS{D1HM`dH}rp(q0~OB,",
      "name": "@Map/MonsterID01"
    },
    {
      "id": "%9%b9Gz?oL#mYP(03L-l",
      "name": "@Map/MonsterID02"
    },
    {
      "id": "o,Udd/C9EGfvKJ~c(0Kr",
      "name": "@Map/MonsterID03"
    },
    {
      "id": "o-m)P~7yx*zd9z-hHQ%V",
      "name": "@Map/MonsterID04"
    },
    {
      "id": "(/ywO{h^a]HU3l~o=V4f",
      "name": "@Map/MonsterID05"
    },
    {
      "id": "/|#`W@-G0CCR[Wx5yY1=",
      "name": "@Map/MonsterID06"
    },
    {
      "id": "6AXrbuzE:32`So31}hRt",
      "name": "@Map/MonsterID07"
    },
    {
      "id": "DjuFn}JBx!SBtVckhT1D",
      "name": "@Map/MonsterID08"
    },
    {
      "id": "-:8*1c+#[?^W^zFdqDHa",
      "name": "@Map/MonsterID09"
    },
    {
      "id": "gKKOoQyVX)AiS/P`x7c!",
      "name": "@Map/MonsterID10"
    },
    {
      "id": "rD/VC/e%ZC}xD*N,k}Q;",
      "name": "@Map/MonsterID11"
    },
    {
      "id": "_0@Y/q2/+pE}hzz/v^~K",
      "name": "@Map/MonsterID12"
    },
    {
      "id": "Am#AdYtUmR1wEUq3^cO1",
      "name": "@Map/MonsterID13"
    },
    {
      "id": "**bDih*AAEQZoycow*5W",
      "name": "@Map/MonsterID14"
    },
    {
      "id": ")d$_^y,r`;[eL0^v1|8o",
      "name": "@Map/MonsterID15"
    },
    {
      "id": "|*Q]2KY_TU)k^x1oI%x_",
      "name": "@Map/MonsterID16"
    },
    {
      "id": ";kD:KPHce=+O;}+,PE$8",
      "name": "@Map/MonsterID17"
    },
    {
      "id": "GD+ys3.Klg$J]T?-IWmD",
      "name": "@Map/MonsterID18"
    },
    {
      "id": "G9L^wWy.ye_wOEy/wnfI",
      "name": "@Map/MonsterID19"
    },
    {
      "id": "ehSE=Yheh]^@V=G-#fj0",
      "name": "@Map/MonsterID20"
    },
    {
      "id": "5nxl#YZTuol=Y2f-q_X|",
      "name": "@Map/MonsterID21"
    },
    {
      "id": "{{vKhyIU3Bb2On9Eu$)8",
      "name": "@Map/MonsterID22"
    },
    {
      "id": "I8;$;@Ec1F-Qb@_1%8R!",
      "name": "@Map/MonsterID23"
    },
    {
      "id": "7[aFNKmTOb%4vIx%j4b~",
      "name": "@Map/MonsterID24"
    },
    {
      "id": "-=88F2J,|V:8)5(IKGl|",
      "name": "@Map/MonsterID25"
    },
    {
      "id": "gWBGBZIG4xufBtb!mt@V",
      "name": "@Map/MonsterID26"
    },
    {
      "id": "mN[Zu-5/C:Bt:PW}D@ol",
      "name": "@Map/MonsterID27"
    },
    {
      "id": "NHHl0es{Y0jAWGAuc$lQ",
      "name": "@Map/MonsterID28"
    },
    {
      "id": "4C_m$;y#X$xW7yL)zb??",
      "name": "@Map/MonsterID29"
    },
    {
      "id": "re##*Z)xQ`n3lPN*J50R",
      "name": "@Map/MonsterID30"
    },
    {
      "id": "c]]IRdNsHj0atbXS%j:j",
      "name": "@Map/MonsterID31"
    },
    {
      "id": "9UrJ:/fb-*K3]?hL)*[(",
      "name": "@Map/MonsterID32"
    },
    {
      "id": "QusqPW.Q)z_y1w:(~7%k",
      "name": "@Map/MonsterID33"
    },
    {
      "id": "{V6056G!pPOx98ZH?K6f",
      "name": "@Map/MonsterID34"
    },
    {
      "id": "eUKd{|EuVqw#yWLs70xa",
      "name": "@Map/MonsterID35"
    },
    {
      "id": "U#xi8dpuPAjOWw3$onH!",
      "name": "@Map/MonsterID36"
    },
    {
      "id": "s|#guT+D@GPgcBL2znqq",
      "name": "@Map/MonsterID37"
    },
    {
      "id": "#UN3hM3TTEKaD/4-@7g[",
      "name": "@Map/MonsterID38"
    },
    {
      "id": "Y5|1JQ*z~^HI.MR,ugtJ",
      "name": "@Map/MonsterID39"
    },
    {
      "id": "qI`e41yP|.~OM4Lw}(RV",
      "name": "@Map/MonsterID40"
    },
    {
      "id": "YJB:uONFpm0aU:BpedSA",
      "name": "@Map/MonsterID41"
    },
    {
      "id": "zP?rX?80Jdb[y^8#P%c*",
      "name": "@Map/MonsterID42"
    },
    {
      "id": "0=Us+5.Uhq|Em*IB/EIm",
      "name": "@Map/MonsterID43"
    },
    {
      "id": "NmFx4_ZNEAY*7H59!)t$",
      "name": "@Map/MonsterID44"
    },
    {
      "id": "5g%Mrp_p7trfY{d(3k)0",
      "name": "@Map/MonsterID45"
    },
    {
      "id": "B0iEtQOcwsbeEjr_kdA{",
      "name": "@Map/MonsterID46"
    },
    {
      "id": "#34wVJ-/|KBw;|3^An-j",
      "name": "@Map/MonsterID47"
    },
    {
      "id": "@j2W$;{MX2i+].pS}Q?u",
      "name": "@Map/MonsterID48"
    },
    {
      "id": "cT`pPtt=yw0Gpyore=C(",
      "name": "@Map/MonsterID49"
    },
    {
      "id": "Xmj~FU-#-EhJlnQpZODl",
      "name": "@Map/MonsterID50"
    },
    {
      "id": ")~~`w(J!bNTVL|YBZgov",
      "name": "@Map/MonsterID51"
    },
    {
      "id": "PXjGn/794:-E/agDaGAQ",
      "name": "@Map/MonsterID52"
    },
    {
      "id": "a!@UeyI{)U`6ZvPv-BkD",
      "name": "@Map/MonsterID53"
    },
    {
      "id": ",).6KISO-B0`v|UyYE!9",
      "name": "@Map/MonsterID54"
    },
    {
      "id": "%6;1aa[#CdeqEIqeKs=+",
      "name": "@Map/MonsterID55"
    },
    {
      "id": "NN$er~=M#Cv4GkTewK4`",
      "name": "@Map/MonsterID56"
    },
    {
      "id": "?9E[H2w!4-Hl.+PnE(_d",
      "name": "@Map/MonsterID57"
    },
    {
      "id": "uex1Q-XvF8$$T4xSrZW$",
      "name": "@Map/MonsterID58"
    },
    {
      "id": "ijKX[Yv+Z~sN*7Zk1~ic",
      "name": "@Map/MonsterID59"
    },
    {
      "id": "e(9/61tLj{IxJyU,H(ho",
      "name": "@Map/MonsterID60"
    },
    {
      "id": "a/=2unm6bePE+n5,iQL/",
      "name": "@Map/AddBuffID01"
    },
    {
      "id": "Lg9!kXf1;5]U3v+FAyt,",
      "name": "@Map/AddBuffID02"
    },
    {
      "id": "Cy[[*NwEHS[52Bo_f{/R",
      "name": "@Map/AddBuffID03"
    },
    {
      "id": "z|J.y7i{~r6Rzi/uoD]h",
      "name": "@Map/AddBuffID04"
    },
    {
      "id": ".^.ck:})UW16SG[{Ksvs",
      "name": "@Map/AddBuffID05"
    },
    {
      "id": "gg,o=5D/*[XT4K6J#Q~L",
      "name": "@Map/AddBuffID06"
    },
    {
      "id": "KLiwJdt.8tP{o]i?V(oB",
      "name": "@Map/AddBuffID07"
    },
    {
      "id": "^m0_sWZp-[=e;K-#YZ8L",
      "name": "@Map/AddBuffID08"
    },
    {
      "id": "}q{r+AiePTbqJ=%BIB.p",
      "name": "@Map/AddBuffID09"
    },
    {
      "id": "sd/iF#*|NI;Npcd!P^]7",
      "name": "@Map/AddBuffID10"
    },
    {
      "id": "L@yMXQ%pwo}C^,|PP[vk",
      "name": "@Map/AddBuffID11"
    },
    {
      "id": "Rde?g%Yv-`4KmC0=JFB}",
      "name": "@Map/AddBuffID12"
    },
    {
      "id": "?2+EKtLs-(vqT8N~Gvt7",
      "name": "@Map/AddBuffID13"
    },
    {
      "id": "X3U{?.~]z{m2$M:I-hGC",
      "name": "@Map/AddBuffID14"
    },
    {
      "id": "yP/Y9au!1rp**=5;X,j0",
      "name": "@Map/AddBuffID15"
    },
    {
      "id": "G~jPz}||3HqPTBHnxf(C",
      "name": "@Map/AddBuffID16"
    },
    {
      "id": "W$0gpZa/hly8MXn7bQL:",
      "name": "@Map/AddBuffID17"
    },
    {
      "id": "vf@5Pz{!!g)_3-Pk!D,2",
      "name": "@Map/AddBuffID18"
    },
    {
      "id": "}7kWik(d+S?`Iu|q=reG",
      "name": "@Map/AddBuffID19"
    },
    {
      "id": "[S:4mn$nQ/gN**Zsu(3P",
      "name": "@Map/AddBuffID20"
    },
    {
      "id": "3-~PeH.;v0|[?8il7-vZ",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "ZY$6:%O|xuz0TI85N4Q-",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "FNX/IV?4F5wQBNF?-iR^",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "k=C7TU6VF_|e~RjlV6o6",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "C|8mb9(3CZUeF0Ft0.ys",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "7Y5rVVC|1`tO@[xs~FXM",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "|,MAEB/sY4=YO:|BJ9eL",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "/N}w]OzO$[ja75V*qc;T",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "~CkA5l=rLkRMcOd7JV_*",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "la;hl-Hp4b;=[z+A_p!B",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "SkE?jr^-0*!~RsHa)wxg",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "T#78^#i=[S!ZJSrl|7Xc",
      "name": "@Map/MonsterID61"
    },
    {
      "id": "JgjDU~G1OdoCBX(2Vu#E",
      "name": "@Map/MonsterID62"
    },
    {
      "id": "e!b{7$W;,dwgDwVj~B~u",
      "name": "@Map/MonsterID63"
    },
    {
      "id": "?4Gj}@^U.i#h1}qf:P2(",
      "name": "@Map/MonsterID64"
    },
    {
      "id": "P{V}!K/mHSJ#|w8v@mG!",
      "name": "@Map/MonsterID65"
    },
    {
      "id": ".zR~K|RfS2*mmd5}w:w(",
      "name": "@Map/MonsterID66"
    },
    {
      "id": "dGctzf;/9KS($(HoREfe",
      "name": "Map/BattleValue"
    },
    {
      "id": "UUPFGH$+c75Af{3jNA2d",
      "name": "Map/IsClear"
    },
    {
      "id": "+W^E=1pSe^b8Z_w#f)bn",
      "name": "Map/WaveCount"
    },
    {
      "id": "~|r1{.w/jjfXLZ~MNhh0",
      "name": "Map/WaveTick"
    },
    {
      "id": "?e=$U;p3|~E{$|o8ow.8",
      "name": "Map/IsSpawn"
    },
    {
      "id": "D*+P;Ov=Eyrc57T{U6;D",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "8]Gh{f~*9fAuAU3/w~*R",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "HZI4qAUyM`R7mTWWx-+b",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "9!?._`a@rWA*Ku6o*?mW",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "{ms[Ou:b|D)A5n0$lcu^",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "1Urg@7Me@,SJ:^Ls?Q6l",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "3Z]@?nX*j!%4W2WOLCJw",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "5{:/9==0hR,-Uy_yBg^%",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "=oVPe,t{)^B,iH.5`*a_",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "@Jil_z=a]m=hsIY=J7f8",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "/0r/q?B_`s?j_nRSP$6W",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "c:iJ71;~F4AVjjj(::=p",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "V,o%G5@FaNd.zL#bqlo}",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "C{%e];5M(wPIf:{OP=tp",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "pl:GL7g|}2`*oK0oO;x)",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "0+HtLUOEFopJQmR^-Li.",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "_dDKvs6q][Q;ut3:yP0t",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": ");SahaBQ8F|w#~lA4mVo",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "iwFxvxo4BXrta*(yb=80",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "TUd(pH;moGPe4N0Y7%2f",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "98|uh?Ctq$H,E|w,awL]",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "^NJZB2:nW,Y5VMT%CjhY",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "=R^2Ap!TNMcfW#WmQWme",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "swm)c^I=7UnT`9h,rU#w",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "~yOI=0IB1vGKVU0359v8",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "8n7Lm5S1`=1Khn~K)^hI",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "zK^whd.R!C%vD$*gOGFG",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "SMnRWtB])8VqO]C5FCh[",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "*9P~aG1a+3Bo:Fu9_Xp=",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": ":r[HAPd(EV`vMdcidqoF",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "fqM4VdjegKwmf;q8,cSB",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "^^`BEqGG.Ojv^xWY_u`e",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "MK`gLnswFm|Rs0%^t`Q]",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "?m{x}$yTgHa7IZ2[+%9S",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "FFQw-;*8execR:Vipi(9",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "n2]Dfx1$F:3`U8`ZC8D~",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "lD29G1d{#uyWVBzd^iW[",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "0N7xGiVs!8s5H@^[zMrA",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "uWpIyA8qM$Q5kF2k3Btn",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "Ata5?uoW/3TdzV%k!?cM",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "5ekyq[yFf(=}T{K9Tl^,",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "=h9B5tzg=,b^kIDK(x}Y",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "HM?|8Dkg~}WfF0kGY-^G",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "]Y8bN~Y/6(hKB,{YJs,%",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "~7L6w5)oAeh%#D}U@;-u",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "u/CfbqL1^]CU=a/b^J6w",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "QW9QqAjvAJk5^fFVAtO{",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "]m(eI%yH;L$(0HxF`hky",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "+J/tBL3VhcY_W}+K(q^J",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "Wx^ZNq$+Ka!47kw7t,X0",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "iX-G{#kKdF=v/tB@zOrm",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": ".L~nOIKApcxEbp;F,i/W",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "HP/8#*6975FL#RC/wL($",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "}4v]#Dz(wBz6%WfcH9Dm",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "eSjvvn([B~t!55td;rr1",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "_Ma$XQ.f!p(Sv#$B;y`@",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "7^NAv#TJMl1K7gpdX7CH",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "^X[]Fy+t_6;njjK~=:e9",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "5{+Y[p]6rX^IQW@TUFKK",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "?;InL+.l0G|]DpQNG=p(",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "6MgRZbS9x58;L))3;~r~",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "`eX;rymSjX?5=!okf6wY",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "f]s=S.L#D]#IP~{7Hv^f",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "Q3BB,vNFZFAnH|%Y}@3_",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "9NF=LJglu:HN#]H1vNd=",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "1^$:d%PH(Z-K)SNv2G{,",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "!awpMxZmEzw3od%euN[^",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "RwpQx[yG$U_TYq|NHKnQ",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "e].!dE(`e,c2.jq;?las",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "Vt5Igi6@WmX9D2y_pPDr",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "+v3f/z/_!Z%uxZG3;i_G",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "E7RTJXtBT_+KdMdG_)6u",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "-`h6weDu}%`2fkffs5M~",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "Q]%yr|[tr$7i{21Gxnc#",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "zEZ7){tuQ~6$y9~,1tts",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "V%k}+|b!D|YNIqBk?+O?",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "Ag!pYD}Z7KPBkVG_Eyxm",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "E@?$KXdiAWz]QW9p,S1U",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "E7J6w;)c1yl=iQZ4hR}l",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "q*j6/`cpYu*{38t5aJQX",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "rUEuvIW])zg~+RSXY(.}",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": ".G}s2qD*3d$(D1_iDbWl",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "q12U*73k=lLkI=6A}Xxm",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "a.gu:EXVRhR{;GAtB_Zs",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "ODJ@vjZofvL=XqAVLHy]",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "$T:n`fG3q]@Ry;$Gd/sp",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "z-%M`YCl_-9te40Bl^c~",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "ZKwqPav%E+)p`VBU*0%6",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "qcUWFe7`N!s=6{+nB}Bj",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "QImdJGW-^U0-:fsF30tg",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "$ea)C?K`C6Sq:L{`},c#",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "$+p9JkIP0p0xy2x9-UfU",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "j6!twAP@F{vmdcmuCYmU",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "m1_AoM^;qQ:VyA[K9CW,",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "[T9HtW8gLoabE~O9tZ5o",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "rGD^q.0jtr2ZsvP#dqsb",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "DA42w1|2M:ZoOX9(Z1S~",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "@zf%}0W5AWFc,Hh#Wexe",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "9o/vi+p|IPMKnBjUk*q#",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "W+`3-i5D(xXKAuC2?!j,",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "i%]KNx3K4HV$wrQR5.WW",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "_dn93GKvG:1=+O|.]5?R",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "s8vaLZkV|;YX.f=-j=}@",
      "name": "@Map/Variable01"
    },
    {
      "id": "E:0F:POqc%_9P}oU;dh.",
      "name": "@Map/Variable02"
    },
    {
      "id": "F5CJ,=isK-(~:D@i)e9}",
      "name": "@Map/Variable03"
    },
    {
      "id": "X:q3s`{;:UrbGi,SpFrn",
      "name": "@Map/Variable04"
    },
    {
      "id": "eS8/nUFN!R/};d())ED)",
      "name": "@Map/Variable05"
    },
    {
      "id": "2.$8D!:-DTO{hUj%AMoA",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "$2c#xny*y8y-nLWfh_:T",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "Ms!S$la]*5j=)vTh*DbQ",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "6bJRaUz;;mgC1YIh3bpW",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "@`kRXG2*;[[T44{:r)qv",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": ",!~)-$Yw%Bxrm}j=w%E$",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "8^qz_/5k{|#}1S6C)rmO",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "1%9q~a_yG97j(i{?J{UK",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "prx/,-fR#F^_f}hqen11",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": "3p|j8#G8~qt=x4AaUh=(",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": "My:6Bw+l1UQIXk5J/b]b",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "pAdq*rT(fRt49u~~6%@!",
      "name": "@Unit/Variable01"
    },
    {
      "id": "s$Okq(mV6FNVmV;u1hYy",
      "name": "@Unit/Variable02"
    },
    {
      "id": "]@$Lx[nV!;KafS!3K|V;",
      "name": "@Unit/Variable03"
    },
    {
      "id": "p!FP4!dWn9U/SkE=Vako",
      "name": "@Unit/Variable04"
    },
    {
      "id": "pEyW(6OP8i^N1eW*AJdR",
      "name": "@Unit/Variable05"
    },
    {
      "id": "^6$LqL0k|FQeJ.DGHK%K",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "EFDx~V:Kf+zC`ktM_?;-",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "/7]o{;Z|XR/5wtA`QT~U",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "N6^6i@X9H7=;{}tDZ$k[",
      "name": "@Skill/Trait/BlastIncreaseKBPercent"
    },
    {
      "id": "%@4|NTUx9PyV7*K0QTAS",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": ";|`eSZo7wY0-FI$0?}FX",
      "name": "Gem shops"
    },
    {
      "id": "{,`}UJ`O,,~_En:*q$Y~",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "E-PI)xe:M61Cv#1dq6=~",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "x1U.r{o;^YEMtcF3x}[.",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "#EI-]]rgqR(usML#=3$L",
      "name": "Map/Wave"
    },
    {
      "id": "H?bHb8dRrJvNPHs(fqu+",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "Ef`PS|leIZ$b|_eYJck_",
      "name": "Map/Wave/Step"
    },
    {
      "id": "YYQ1t%[thzyDRB9L)k:o",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "6Go0pr|.[.i#k{:G$1if",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": ",-EGeRF8@WmL_~jx4~AG",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "8|=m!|ULMdsh?j?6*BL`",
      "name": "Map/Wave/State"
    },
    {
      "id": "vb9:I?GMu?)%BZlpdgfp",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "mR;QY,GY;]l0whay/DXM",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "ap/A/T6bS}M;:FSc$#8y",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "4e^`eouXG[)|}8GVDvC#",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "Z^}p0A9q3a0fVp=(g^$;",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "lVd7}$5@NV@CJ^w]VU.6",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "Gps{shgv1xaq]uz[HAPP",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "`tE.3fZ7{TRk$0*HuG`R",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "wee^ZlFNcOuu5ieV05{U",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "W2_LoK}E#FXn`lL0!fnt",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "/H$IR;bu)uk$^_3Wm^:5",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "X8.OzNgik)$Rjpb)1Q@E",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "Sky}2E#em/W]epMbDt_S",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "dxg=XQ{zR-N-C{Ok7rR`",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "cYb~98u-U(Vgm+]Lb*16",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "dKM`[U@QO`Pfa^Q]:TwP",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "F55hLG:}wct?1Jdi]O;~",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "%_$Lu9u2M_ca_zyD:p=y",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "Fd;{/`s2U!;07RR;S~lU",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": ":e24?:b/|-9XGsc(mq}8",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "d?O.B?[^h.V:ZGUz.kN%",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "}jPkX;4|[OUWO1[{5T_I",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "vd^-kc=_GZxG!iG+1ZNr",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "(!%FXZ7(vDbc|u5%V!Cy",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "B4Mo5Zbwdfe@ae;rv]J:",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "q]hl`dUF=o+-$I4tUl2,",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "^X)$6nw^|l7?O=(@XTWT",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "(6#UH/{2gEpOQD^lJtz^",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "*)i_F?h]y+Fs4oK~4JqN",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "TOF:QlMqkxN)elcID%*=",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "TgSr$tt5JO-7]z6_,|[U",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "`;O7LYfzqNJ=HRvygJK?",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "9EE69SG42q#@sh)3XpQt",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "ptw,^CIo0q5Lk0}?Hs{r",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "84HzGy4I;O#}`btsQZ;l",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "U6[x6IH:dr`flU;7h0{f",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "MvjHq,8C#G!Zt6rYpa1o",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "]Wz[pq-N=dXKpCk8tAlY",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "LZdUgQ|_UYjK);SAbiR1",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "m?ww}Ujo,8UCP,Zb)Hm~",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "7uafUxuV+_}Xwn0^C:MD",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "_ep~~s)l;Gi#qqdLT^iz",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "-g}`}@S9d69Rt~IZJ^j[",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "fIPZSO$-jUjs0vf9nU8D",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "7#LbbCjar#x=D%fd=bzL",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "+,4[QEi@8r)PWP=Bo-.z",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "k)#o2F?W^N{^OTGT~v`r",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "lPN4u$EO438*)+v)u[}N",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "z2Rvm!}Gfc6YOlfRD/A#",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "740^@r;,BH:,nb[oMj|R",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "ABK:.%=4_I0DxVXWc-br",
      "name": "Gem"
    },
    {
      "id": "03=%.S_Pjht2d,iUeMZ:",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "UHTLhoqbS~0f7$PK8ErT",
      "name": "Map/Player/Moving"
    },
    {
      "id": "xGLk[bD$m,Kw@NPJS+:}",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "kBpiqB(MM!jKykD}193?",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "m[^Z]x;4Vrr;[h[$lFRE",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "z%!~]F]XLuoQtRofTp+}",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "A93YdQxp[vKsT#0gd{JG",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "qH1^z]rT5XS01C{P(~1w",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "UkNM$B`I(st^;YY/bD;l",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": ":GZz#]=)UZZF!Wg(8)1#",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "r1%fz[3Ye8G6,yO]!c8+",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "QM~Ip-H4xFuT(D~[z+CR",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "dV`T%JV{|/7pBjIgB/eh",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "{~qEWS6few|W:+2x.:.r",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "v:ux1L~D[5wIYw[B%d+h",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "!^-:F+r@||KqO}o)j_2?",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "^7s%E|%U:EjD@_^DwUy;",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "0`XclD0SWG]AO1OcKpSJ",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "cs/@wX#K?NP@:r+N8%z$",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "fI{u^la4rOF7mL*YYZw*",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "^C(zEi%|ma{@k{L?,svf",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "BIS?~,{Lf+O^y(njh?f]",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "cB0`ob3{H$@,MY~E4-qn",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "5nG6Hl}dm:bCsMbrYHQ8",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "c)=nLbtW+IljR2w8KGyR",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "UYg5i?ZCY}}3UJmQGpBo",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "BoQ*yOwj!c:g@{O4mmK5",
      "name": "@Map/Progress"
    },
    {
      "id": "ZU^VHk3(~D+8W[|r=/f~",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "9TH=;H16F5=(;@Q^-7D4",
      "name": "@Skill/Variable/05"
    },
    {
      "id": ".$f:IL`*.2_}WysbH17:",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "}g|3`blT:,.-VQkHXg[1",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "#2rXBH%O[WpR|B%XEW%i",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "gZ@:XU;wbC%|s,r+N17e",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "Ac`mdxiy^9ZM`Ni(kluZ",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "1mfM3i^mf$L6Uz}BI+!^",
      "name": "Map/DisplayWinningTeam"
    }
  ]
}