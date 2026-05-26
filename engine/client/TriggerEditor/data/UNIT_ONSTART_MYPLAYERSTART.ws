{
  "blocks": {
    "blocks": [
      {
        "fields": {
          "TYPE": "board",
          "VAR": {
            "id": "N4@%dE}MP%vp2:-C?ge4"
          }
        },
        "id": "Yh$1Hs%`5EgJ7XO3EV21",
        "inputs": {
          "VALUE": {
            "block": {
              "fields": {
                "THIS": true,
                "VAR": "unitVariable:PositionX"
              },
              "id": "#!9AM2`GekXhNhN|:5ND",
              "type": "variables_get_reserved"
            }
          }
        },
        "next": {
          "block": {
            "fields": {
              "TYPE": "board",
              "VAR": {
                "id": "kJsjB}fTFik@}d:dujyM"
              }
            },
            "id": "-Q{|.vaIbu@@I?bSt2J]",
            "inputs": {
              "VALUE": {
                "block": {
                  "fields": {
                    "NUM": 0
                  },
                  "id": "5KC@xiYb.8=j%%9-:*4t",
                  "type": "math_number"
                }
              }
            },
            "type": "variables_set"
          }
        },
        "type": "variables_set",
        "x": -245,
        "y": 405
      },
      {
        "id": "JpH]f7^RT8MJK/{_Ik6m",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:AddBuff",
                "THIS": true
              },
              "id": "p@@YK[0]~7uOB.7))X%N",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "VyY!,Gx_^R4YBs4h/3Pq"
                      }
                    },
                    "id": "jb)~(9wdMPGy~r5#iNbH",
                    "type": "variables_get"
                  }
                }
              },
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "NEQ"
              },
              "id": "`9eiv93tQ;Z0N-p5SXZI",
              "inputs": {
                "A": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "VyY!,Gx_^R4YBs4h/3Pq"
                      }
                    },
                    "id": "Oe3NxiGeoP#R^Sk!:C=S",
                    "type": "variables_get"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "5%d`z5((/xsn91mf[cS}",
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
            "id": "V1gzdVtb(z5{_sqDj)A?",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "unitMethod:AddBuff",
                    "THIS": true
                  },
                  "id": "vKqA_6(eQ?O|Z;CWAH9g",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "extraState": "<mutation></mutation>",
                        "fields": {
                          "TYPE": "board",
                          "VAR": {
                            "id": "z!8|)-8BZtr{ZVMGd6N["
                          }
                        },
                        "id": "3QIH22]T-epAk=~pj*K.",
                        "type": "variables_get"
                      }
                    }
                  },
                  "type": "function_call"
                }
              },
              "IF0": {
                "block": {
                  "fields": {
                    "OP": "NEQ"
                  },
                  "id": "=4W6RBRwcbBt)o5_A@zQ",
                  "inputs": {
                    "A": {
                      "block": {
                        "extraState": "<mutation></mutation>",
                        "fields": {
                          "TYPE": "board",
                          "VAR": {
                            "id": "z!8|)-8BZtr{ZVMGd6N["
                          }
                        },
                        "id": "z}mmRutRm.qnXa?F/vPW",
                        "type": "variables_get"
                      }
                    },
                    "B": {
                      "block": {
                        "fields": {
                          "NUM": 0
                        },
                        "id": "AxOzQlrE8^LM5aLaF$=I",
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
                "id": "2JwlZk8$a$SGQw1k00(P",
                "inputs": {
                  "DO0": {
                    "block": {
                      "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                      "fields": {
                        "NAME": "unitMethod:AddBuff",
                        "THIS": true
                      },
                      "id": "BC@c3W:?V=I1^sUCieq_",
                      "inputs": {
                        "ARG0": {
                          "block": {
                            "extraState": "<mutation></mutation>",
                            "fields": {
                              "TYPE": "board",
                              "VAR": {
                                "id": "N:^rtNn.(*eZN|RNw7#o"
                              }
                            },
                            "id": "sl9~w/J1v-fJOAx5VF2r",
                            "type": "variables_get"
                          }
                        }
                      },
                      "type": "function_call"
                    }
                  },
                  "IF0": {
                    "block": {
                      "fields": {
                        "OP": "NEQ"
                      },
                      "id": "i%!iUtpNoun}_SL8~XV=",
                      "inputs": {
                        "A": {
                          "block": {
                            "extraState": "<mutation></mutation>",
                            "fields": {
                              "TYPE": "board",
                              "VAR": {
                                "id": "N:^rtNn.(*eZN|RNw7#o"
                              }
                            },
                            "id": "57Oj[+K`ad$l-3L?+/(y",
                            "type": "variables_get"
                          }
                        },
                        "B": {
                          "block": {
                            "fields": {
                              "NUM": 0
                            },
                            "id": "#dL-,2jd,K+l0!i;fLi6",
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
            "type": "controls_if"
          }
        },
        "type": "controls_if",
        "x": -249,
        "y": 592
      },
      {
        "id": "]BI^7@vq06ObY8eELd42",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"5\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;DirectionX (default = unit X)&quot;,&quot;name&quot;:&quot;DirectionX&quot;},{&quot;comment&quot;:&quot;DirectionY (default = unit Y)&quot;,&quot;name&quot;:&quot;DirectionY&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:UseSkill",
                "THIS": true
              },
              "id": "[h5?FPxWifVC?s;V`v6^",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "SK!0ap#o}HK9us+kskRt"
                      }
                    },
                    "id": "f6K/!jBNuvQ%jTh1|UqD",
                    "type": "variables_get"
                  }
                }
              },
              "type": "function_call"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "NEQ"
              },
              "id": "%:c1R8-5nHOXNLtF0x-v",
              "inputs": {
                "A": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "SK!0ap#o}HK9us+kskRt"
                      }
                    },
                    "id": "^d4c~Xjb^b%XORS3v4m)",
                    "type": "variables_get"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "ws{sNK`zN$~z94eL5Fc`",
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
            "id": "ASf5IzXjThwg=0F]1,HI",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": "<mutation itemCount=\"5\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;DirectionX (default = unit X)&quot;,&quot;name&quot;:&quot;DirectionX&quot;},{&quot;comment&quot;:&quot;DirectionY (default = unit Y)&quot;,&quot;name&quot;:&quot;DirectionY&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "unitMethod:UseSkill",
                    "THIS": true
                  },
                  "id": "qvwWta.d?-;XtOM[IdX{",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "extraState": "<mutation></mutation>",
                        "fields": {
                          "TYPE": "board",
                          "VAR": {
                            "id": "(OK*0IIF9UsFz=QWf8xM"
                          }
                        },
                        "id": "MPB4un-Mpcj~TEkXwjFA",
                        "type": "variables_get"
                      }
                    }
                  },
                  "type": "function_call"
                }
              },
              "IF0": {
                "block": {
                  "fields": {
                    "OP": "NEQ"
                  },
                  "id": "*M`;B,7Qw1A.W0Pg1y@S",
                  "inputs": {
                    "A": {
                      "block": {
                        "extraState": "<mutation></mutation>",
                        "fields": {
                          "TYPE": "board",
                          "VAR": {
                            "id": "(OK*0IIF9UsFz=QWf8xM"
                          }
                        },
                        "id": "NDm+K+GtF7Y,}FP%{;s7",
                        "type": "variables_get"
                      }
                    },
                    "B": {
                      "block": {
                        "fields": {
                          "NUM": 0
                        },
                        "id": "tav7ZYWOwr2jQ~p~NP|(",
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
                "id": "pR0BDh`gyI{fSV)t:G;o",
                "inputs": {
                  "DO0": {
                    "block": {
                      "extraState": "<mutation itemCount=\"5\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;DirectionX (default = unit X)&quot;,&quot;name&quot;:&quot;DirectionX&quot;},{&quot;comment&quot;:&quot;DirectionY (default = unit Y)&quot;,&quot;name&quot;:&quot;DirectionY&quot;}]\"></mutation>",
                      "fields": {
                        "NAME": "unitMethod:UseSkill",
                        "THIS": true
                      },
                      "id": "!.1.zkFB0jBB5XNB$Qmt",
                      "inputs": {
                        "ARG0": {
                          "block": {
                            "extraState": "<mutation></mutation>",
                            "fields": {
                              "TYPE": "board",
                              "VAR": {
                                "id": "u~7E|O}-~A+Bh;4,GEYz"
                              }
                            },
                            "id": "TwC{PRTyxk_kf@ReJSv2",
                            "type": "variables_get"
                          }
                        }
                      },
                      "type": "function_call"
                    }
                  },
                  "IF0": {
                    "block": {
                      "fields": {
                        "OP": "NEQ"
                      },
                      "id": "tqgeaO/^zo1)nW_h11_t",
                      "inputs": {
                        "A": {
                          "block": {
                            "extraState": "<mutation></mutation>",
                            "fields": {
                              "TYPE": "board",
                              "VAR": {
                                "id": "u~7E|O}-~A+Bh;4,GEYz"
                              }
                            },
                            "id": "]0iPxV:DK.,.FLf;ux;_",
                            "type": "variables_get"
                          }
                        },
                        "B": {
                          "block": {
                            "fields": {
                              "NUM": 0
                            },
                            "id": "4?AKd3j_dN8dfyM)I8{4",
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
            "type": "controls_if"
          }
        },
        "type": "controls_if",
        "x": -245,
        "y": 1205
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "UNIT_ONSTART_MYPLAYERSTART",
    "period": "0",
    "triggerType": "0"
  },
  "scroll": {},
  "variables": [
    {
      "id": "{,;hH0mSCnlI_mnGc?pg",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "h8GFD:RrvMlUbYO.:gHY",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "EKoMP8ie$F}^W$sp4%R9",
      "name": "Unit/Time01"
    },
    {
      "id": "}[x{#I}}2/_uWN=dq#$^",
      "name": "Unit/Time02"
    },
    {
      "id": "0~q!Z=SRy)F,4dpqC@aH",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "1U#V,iBPLSgZ7p_j*65s",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "8Q,8}RLrmk1oZk=K1{AF",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "N4@%dE}MP%vp2:-C?ge4",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "UfEw`_[|]:ciTXV6Vk;R",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "hlA0]lx:?i?:3Bgv]{wE",
      "name": "Unit/Tick"
    },
    {
      "id": "A*7K}[qbq)59:2{^(sb-",
      "name": "Unit/Rome"
    },
    {
      "id": "$C!aAUZPBGn[1XhG]yKA",
      "name": "@Unit/Delay"
    },
    {
      "id": ")WwR!fH`]8CthHjClexc",
      "name": "@Unit/Range01"
    },
    {
      "id": "?49_[KGN{=4YdC1K%gdD",
      "name": "@Unit/Range02"
    },
    {
      "id": "RLy#]=.6Kro..Ql;:+e{",
      "name": "@Unit/Range03"
    },
    {
      "id": "qo/6^fsyF?7S-[dx7%3m",
      "name": "@Unit/Range04"
    },
    {
      "id": "fyvcXy#|9D{2iCq+-|4[",
      "name": "@Unit/Range05"
    },
    {
      "id": "Rxh+VGo0m%u|:KK%;stP",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "{e,+eZyC]=u:N3D)y45v",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "*3.iml4p[~Uj63|H_t!W",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "c.tly6W`jEga:K7x|#A]",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "QN$AmW]jW8uUUb04+^u{",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "Zw2y:$:{!fhD.`W//T|c",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "cd,(Biuei7Cp%6nNNLg|",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "BqhmpbM;2CIT#XV;VM`l",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "]9Z9u,^_ejAmo_g7Jx0b",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "lbb6Tbk9KB#Nedz;60h8",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "i3QN*$-6no;tPiiCn))Q",
      "name": "@Map/MonsterID01"
    },
    {
      "id": "TdPqZDm3Ba:%u}=0f)xP",
      "name": "@Map/MonsterID02"
    },
    {
      "id": "qQ^(q`E*Id_$hRM_Jk)H",
      "name": "@Map/MonsterID03"
    },
    {
      "id": "D-y;,6{|B]WSQ[~}.kxW",
      "name": "@Map/MonsterID04"
    },
    {
      "id": "#8{J0XJv2Z!@5r~kz!K@",
      "name": "@Map/MonsterID05"
    },
    {
      "id": "Rso~n9?wL`jEqO#|X@Xf",
      "name": "@Map/MonsterID06"
    },
    {
      "id": "m$)AgaasnTeYwIb60~}N",
      "name": "@Map/MonsterID07"
    },
    {
      "id": "pj`6N!qEZ])xgi4tEe5`",
      "name": "Map/BattleValue"
    },
    {
      "id": "QtBRZbZA-#dQNA+Dz7ui",
      "name": "Map/IsClear"
    },
    {
      "id": "uCh{93@zHi#IL!pmKWxO",
      "name": "Map/WaveCount"
    },
    {
      "id": "BUe*Ex~82{:{H$C3aEp~",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "bPWVN;nKUk(Y`6;Xxj@6",
      "name": "@Map/MonsterID08"
    },
    {
      "id": "/)[m9#FI]+:Z5s;zav]z",
      "name": "@Map/MonsterID09"
    },
    {
      "id": "ExzxZJRC33-76w+LpF[#",
      "name": "@Map/MonsterID10"
    },
    {
      "id": "0*C[x(z|{)xzG8+ltKo+",
      "name": "@Map/MonsterID11"
    },
    {
      "id": "c.]PD%_`-n;4VY?Q-_J-",
      "name": "@Map/MonsterID12"
    },
    {
      "id": "dwlTd|+z32_#dH{dO:Hw",
      "name": "@Map/MonsterID13"
    },
    {
      "id": "]?0zex|+T2Cf08,z!h?K",
      "name": "@Map/MonsterID14"
    },
    {
      "id": ".0m=VSCEDIVJI%Gn;D4O",
      "name": "@Map/MonsterID15"
    },
    {
      "id": "H}Xx8W5KKLzmq@!qjxuS",
      "name": "@Map/MonsterID16"
    },
    {
      "id": "i]/rswVD$lbZ8mkc#8e4",
      "name": "@Map/MonsterID17"
    },
    {
      "id": "Qmk2,O?PRy~,(VN[I{vq",
      "name": "@Map/MonsterID18"
    },
    {
      "id": "#SkuY+v+j?k|PD`H:i.d",
      "name": "@Map/MonsterID19"
    },
    {
      "id": "t)3dGg6k@:zNzKds{E7T",
      "name": "@Map/MonsterID20"
    },
    {
      "id": "6p:A0*g:iuvEnUolZlX?",
      "name": "@Map/AddBuffID01"
    },
    {
      "id": "wh*/N^aVUR6cP1gp},oR",
      "name": "@Map/AddBuffID02"
    },
    {
      "id": "O=LqNYHp]jc%YrkfmsW:",
      "name": "@Map/AddBuffID03"
    },
    {
      "id": ";hu1jIoFvdo8WW6FBISs",
      "name": "@Map/AddBuffID04"
    },
    {
      "id": "j|KsGoMtyZPTG?b$rK@?",
      "name": "@Map/AddBuffID05"
    },
    {
      "id": "Wcnwp^o:oMZ?fBL6pNpc",
      "name": "@Map/AddBuffID06"
    },
    {
      "id": "#qu:C0%s^({FY#w=^!S!",
      "name": "@Map/AddBuffID07"
    },
    {
      "id": "aD6}Vvx5E#qlniELRe5m",
      "name": "@Map/AddBuffID08"
    },
    {
      "id": "-,dBOQ;gAr@CTI61(h0{",
      "name": "@Map/AddBuffID09"
    },
    {
      "id": "/@p8zS6Z?ZEnO!?{kfe9",
      "name": "@Map/AddBuffID10"
    },
    {
      "id": "}6qFfNh;|zZ76)ei9fo:",
      "name": "@Map/AddBuffID11"
    },
    {
      "id": "Gc)-D7jy58g0E4#+rnRl",
      "name": "@Map/AddBuffID12"
    },
    {
      "id": "1iIcu.Inyu|jpx0a{=Tn",
      "name": "@Map/AddBuffID13"
    },
    {
      "id": "9^03r:_y*T7UQA5Ge!7)",
      "name": "@Map/AddBuffID14"
    },
    {
      "id": "tlW5JN7@l^4PK6Rk;CP}",
      "name": "@Map/AddBuffID15"
    },
    {
      "id": ":4qk+H5m:+Wd(}2[RF}=",
      "name": "@Map/AddBuffID16"
    },
    {
      "id": "e_n$lPwsj]h%#l25}$Ds",
      "name": "@Map/AddBuffID17"
    },
    {
      "id": "3T]tS13:Li7+StO%L3p.",
      "name": "@Map/AddBuffID18"
    },
    {
      "id": "/`g,aIDKbw)o:X@i{lC*",
      "name": "@Map/AddBuffID19"
    },
    {
      "id": "FVyiyAmX?SIOEP@DUv4s",
      "name": "@Map/AddBuffID20"
    },
    {
      "id": "1($;7-@ehC;35,CB{!Pj",
      "name": "Map/WaveTick"
    },
    {
      "id": ";:#LS]%Jxir=Dc;vEpuo",
      "name": "Map/IsSpawn"
    },
    {
      "id": "]({sIHf~d6-Se=,OekX|",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "xOhxbz||/J[m!vxVcLbS",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "_Z2pLB3hn^b~oRH7XQNM",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "Q1z1T:z{Q/#X9M)p8KPf",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "|fzAqw]vm^jn|$]P(dra",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "4AfIWT*Y)|CmrRHeV!Sr",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "._J]~Vm3(@meH(~!R~)f",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "{p+}dZ2zcTqB#t.x/;qG",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "3w7F#%l_/dMVkug*KypL",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "-;gCkPy/Kn_sKwpC67kK",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "r[0xo[sp0nP0EJBhv%*i",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "O9Bt%.u2oYa%-y`h0R1z",
      "name": "@Map/MonsterID21"
    },
    {
      "id": "inbkDN4/fwiJ]q*.3aei",
      "name": "@Map/MonsterID22"
    },
    {
      "id": "U_8m6.T)?YME/,G$oj_W",
      "name": "@Map/MonsterID23"
    },
    {
      "id": ")#kF`jh;`|w[Z}u@Tc;A",
      "name": "@Map/MonsterID24"
    },
    {
      "id": "TZ_=FHVJ]Q^B19Wln2c[",
      "name": "@Map/MonsterID25"
    },
    {
      "id": "Q{Em*)Ia4Ai:g`XH8P`{",
      "name": "@Map/MonsterID26"
    },
    {
      "id": "e+1-o*Y=MxIa-*$tD?._",
      "name": "@Map/MonsterID27"
    },
    {
      "id": "SiDu#+u|8vmzN89h$:|Z",
      "name": "@Map/MonsterID28"
    },
    {
      "id": "OOFt/)[U(t+lll3I%r!c",
      "name": "@Map/MonsterID29"
    },
    {
      "id": "KH9y,c2%8IW254^gE]0P",
      "name": "@Map/MonsterID30"
    },
    {
      "id": "r0cVJFNl6E;Hw?0(MMy=",
      "name": "@Map/MonsterID31"
    },
    {
      "id": ";Xw(]{:qoe]LrLx5CMjj",
      "name": "@Map/MonsterID32"
    },
    {
      "id": "WIKO6N#*8w*MW3|fU*{8",
      "name": "@Map/MonsterID33"
    },
    {
      "id": ")~+WBC9cpi4Gcku6H-qP",
      "name": "@Map/MonsterID34"
    },
    {
      "id": "|PYe9F^xjHyqxpT5CH;2",
      "name": "@Map/MonsterID35"
    },
    {
      "id": ")#1@a01Lep2.01u$~KCE",
      "name": "@Map/MonsterID36"
    },
    {
      "id": "lizK$Agx2ujd},EP#*y_",
      "name": "@Map/MonsterID37"
    },
    {
      "id": "[G~FP:YF5;@*:Y;1(0CZ",
      "name": "@Map/MonsterID38"
    },
    {
      "id": "+|j.RM:VH~V,7PZP=H/Y",
      "name": "@Map/MonsterID39"
    },
    {
      "id": "=RFXW`%Jt,f5#NUKUU{,",
      "name": "@Map/MonsterID40"
    },
    {
      "id": "r#R)F;(#wEU-AI_~uGS6",
      "name": "@Map/MonsterID41"
    },
    {
      "id": "=-Z7j}HlnDxb$dmu6G_C",
      "name": "@Map/MonsterID42"
    },
    {
      "id": "?[Ppl36X;G^IXs/[fDuE",
      "name": "@Map/MonsterID43"
    },
    {
      "id": ".Y[LeO!,IXy3BTl5$qmq",
      "name": "@Map/MonsterID44"
    },
    {
      "id": "SDDqg7/iWex5k?GGi(0:",
      "name": "@Map/MonsterID45"
    },
    {
      "id": "];}84o^[V:R=S|176?Wg",
      "name": "@Map/MonsterID46"
    },
    {
      "id": "zSt%60:j40CfhINUAi.4",
      "name": "@Map/MonsterID47"
    },
    {
      "id": ";|Z|PUDS}*T$yq!D{%wV",
      "name": "@Map/MonsterID48"
    },
    {
      "id": "]3U@KPOi(Yn3=AdI.AzK",
      "name": "@Map/MonsterID49"
    },
    {
      "id": "U4O8}lV=hP-z:1H!]rj-",
      "name": "@Map/MonsterID50"
    },
    {
      "id": "2+_,c.{^p_Ti*5bKZI`s",
      "name": "@Map/MonsterID51"
    },
    {
      "id": "6y:A%;Ec~^+{=~8*olG7",
      "name": "@Map/MonsterID52"
    },
    {
      "id": "sRs1t[69/tiX[kai*Wis",
      "name": "@Map/MonsterID53"
    },
    {
      "id": "={-C0fy-Th1NLrCt4KIk",
      "name": "@Map/MonsterID54"
    },
    {
      "id": "(L|Q}zSg-vroU4^n:SX`",
      "name": "@Map/MonsterID55"
    },
    {
      "id": "Pr/0vJi_u;mK]729ZlS#",
      "name": "@Map/MonsterID56"
    },
    {
      "id": "l7?L^e7GxEn)[lAY;{W;",
      "name": "@Map/MonsterID57"
    },
    {
      "id": "$_1EuBk(]$aR!`A/$hpn",
      "name": "@Map/MonsterID58"
    },
    {
      "id": "jk(vrn{|CW=yV:6X5XJV",
      "name": "@Map/MonsterID59"
    },
    {
      "id": "PklNKqEYz.mf}KrIXp32",
      "name": "@Map/MonsterID60"
    },
    {
      "id": "o.i;nBR2mbm{_RKX5?hi",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "^VB-vwOQ;i*pj01r!.61",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "Fft)3fC{Z6u1y=F:kx%p",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "9OIF!SVUfz@^`p,=(DXg",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": ",;(1UHis`T5WKAU0[FFt",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "y$XeS.MjBVS+9c1bg.dF",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "on57!0-UpEIp9xo=we:$",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "m0c-#J.ipXIae?{SGJeU",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "M%JPPA^:+SUH:slgQ+-D",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "_HZfET;rY+IB=B6D{)09",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "xWYC$+y_0VAKf]g}POJ$",
      "name": "@Map/MonsterID61"
    },
    {
      "id": "V39OX@,wPVX{-eoG^OG2",
      "name": "@Map/MonsterID62"
    },
    {
      "id": "[K063FxEdxR{9.]i(p6Z",
      "name": "@Map/MonsterID63"
    },
    {
      "id": "$E,*!K:%DuTGa7ZX!:di",
      "name": "@Map/MonsterID64"
    },
    {
      "id": ":L8.P6ipJ!|B3@vTH[2:",
      "name": "@Map/MonsterID65"
    },
    {
      "id": "a31L@nu%9;wTo]TYiJJ~",
      "name": "@Map/MonsterID66"
    },
    {
      "id": "/!dL]2w-EuBCXY;!P`iO",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": ":e$TK:o=MUfBTYN{Pha@",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "j1,HotY-qz!@E}@02nB~",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "fK8?%P4DsD7o!2HC^|,o",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "?IV3|PyOtLq:+W281_Gw",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "mfDMp:[3@:w$?Y!n(R,z",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "gw_bF/mZU_p=Gs8tqy)`",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": ",`eCLQ/`%UN5+--RviTs",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "`crsZ,O|7@j1,0lv-bP2",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "TaBK+csNX)AD8XF1%^pn",
      "name": "@Map/Variable01"
    },
    {
      "id": "y$|DT0PB2?ajR!;K+*Lk",
      "name": "@Map/Variable02"
    },
    {
      "id": "M]:U2-t`j^G;Cvw0^abG",
      "name": "@Map/Variable03"
    },
    {
      "id": "F$$3fXpC8HvYjvF(:7[]",
      "name": "@Map/Variable04"
    },
    {
      "id": "YtD`pozbR@}jFTA1MV=6",
      "name": "@Map/Variable05"
    },
    {
      "id": ":A6m$5Hx2Pc]w|YG,u:4",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "X]jHNhsJ.7Aqm;5M|b7V",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "lFuJ=MpRWM7$iQ_bguGD",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": ".zfUVTFSH]0*hqY_W)Ef",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "btOT]K0cJwot|QY1|J8c",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "Q3cajzy(n7c3oRnK:$*L",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "`ddXzHKa`|$G].FCU!1Z",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "z6$=t!8V)y_}s_DXxHhT",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "^+`(%JiDGk;]L[78s~QM",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": "R_N}LV0bSQr;{bLaN)b*",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": "%vG=/~F1b:)H-b;ww@s,",
      "name": "Map/WaveStartTick"
    },
    {
      "id": ",d?nY6pyE7Ep!Cv_:M^n",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "/HVn9,:C`%XDr%6M9?^}",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "|.*.lrNE/@BkOy*pm]{=",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "K~=85WATfRPTpYr1FH`a",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "f5D^mGIIU9OlVdBvZD%8",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "Ffq;.i0esWx/{0%76/7V",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "/8Y*B3@ReAVbod[-[po!",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "%`Cx1Y~C#ePDpk6PBW}M",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "w?*]RKT@*ZYsC:]O@{d-",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "sgOktXJP?1T.LECvVyM}",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "OBYV:^Wz|2ioaCT|`u64",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "!R_Gh%}(w(lQ;n%kL!%y",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "@Aq+,oqo*S3]A@Dp?~E(",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "6y7EJ).7wq@P_,`w[-u^",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "h5X${K!E#El:t6avAP`x",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "_YG82{jTJ25D/~P=v=l)",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "w;|d]P%;m.:kMRw3P2LA",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "#^]@|_CX6=]FN+,tu7ca",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": ".D,#eySxS~NpL?pE3#5z",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "3KkMkn_,.*F27rqrDj:i",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "Vr|Ld*]`X/16o$8QiamM",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "84FHpfn;%84~E4TO0eki",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "mtUQ4@jq+5D-y/.Z^PUx",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "2A3UQc^ZWED1n7x@T}k!",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "o5DOz-A-kl@$~?LY4`iK",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "Hr=V$ZDJrHb*}fSOkH(|",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "toLA4x=Wz%5)!w?o)jua",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "Ts_L#wXmE_eEktCXF)cd",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "kkZSqIu]i)`BUV*NAoDV",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "idsA@AcS}9I=W]GJ{wo[",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "(+ktY5I`]EG%jUpQ3~zJ",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "I^nBPYb0,+D7k[Y^(h_e",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "~Z#UnnqoZJX)r:M|3MQ$",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "8(+|Nz6%FdesZS(Q?zU#",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "W~|N4i)nE)M|e-]3nHO1",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "V2[i``{YS#{Du)BflvrW",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "/zBYvh`O=bQ;mUVQr34?",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "S^!Gc2@Rk!#fV/r7gNs_",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "M7A{?QNJ3.ho$K9VFQil",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "=sueh`|ug{-OM.kVhw^i",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "33wKANJ3HS?{Eo3;lmhk",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "F`bw@B8w0qcQ^:PI8lbD",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "KsYK-D~98z)7(K3NQP65",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "p]3WW@OFg0zE;H7^0O-7",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "yT.+_EZaKr*UtdfNe;1y",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": ",_q4|q~4zoj%EXODM18`",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "wbtrd8{^S**^vXFYqpaz",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "SJK^FShwoPnkTAsBEVR?",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "}^~y]Cn_VUN30JE:gsns",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "e_/lM9_nHK=Iez7(=vti",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "}#KPhT94tmxjEpa6;0X2",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "bcBS.V2:4QQn1lhf/Xr@",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "TL|?D(Fa@pi{AT(gDY*O",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "f2#Z[m[8/t:|xyFpCB%5",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "9fXclG,OfVS4#__/JQ3:",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "I*j7x8s+CDv[l9M-P`_p",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "P=D1vu@|2DYr;T2%+P[3",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "8-EX^ggV40XYC7:^~O@_",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "K16W}igEC(sBB2:@Y(^D",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": ")$R4)LZs_n1f=(8RCKg1",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "Gpx`M1sG2us)HFag?4wc",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "]z`bn1zJS#-%]uM1C^-x",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "g%{5@WXa4wArdg[(luKb",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "I1+k;L`|xZWl`a(tE3A/",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "hMU=sd!j~TzS)Sl($)IE",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "]pZ(/g?^/L8Zj8aX!odl",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "0/Ino(5brUR{Z@@}D2N]",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "=Pcsq(3p/jwX-q%?AU`*",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "?%h.}^`Sn`QONI_RPIM!",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "@:BO;m(8PI~siIx_rp%l",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "i~UbevI(*8ixQ0`WZLuj",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "SgbFi/#wi|R6(:U+.*4n",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "UKeh3m;}bfFE=Fa9-vUo",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "l5`(Hv%F$vN4g:]lxI$`",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "6za!EJs*2;?*5]nVicc:",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": ";1]#D/o`}q[^?{ksk;Q#",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "nOW$.]lEUoOKX*vMo:(}",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "6X`rZWURm~;5QPb,2oju",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "um]}:)ZQ#7rx1S09n+#*",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "0g8*=3.OQDsgw;{4n9#6",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "_T!@K;M;ahK~;Ex6:[)H",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "oLL/=t|^ckC?3YgCuqG7",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": ")OI.h0D0F[x|BLZgQ+2,",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "mH%RzIPtAmkrng/uF-su",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "!8L{J+0xGni*c1I(b$-h",
      "name": "보석 상점"
    },
    {
      "id": "[}C@*i=(]0r$B;rh0ug$",
      "name": "@Unit/Variable01"
    },
    {
      "id": "B7V8?QinEw$J3:~,:j|+",
      "name": "@Unit/Variable02"
    },
    {
      "id": "sDdLMya~(N=%6a$:dWJu",
      "name": "@Unit/Variable03"
    },
    {
      "id": "9wv$Mxqm.$o010F7*!Z`",
      "name": "@Unit/Variable04"
    },
    {
      "id": "$eE,AdkQ7Sg;@k-ozL}1",
      "name": "@Unit/Variable05"
    },
    {
      "id": "z@Dz@+(EG3xK`3`Hr?j%",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "U+nR19R;W3=gM|GkTm?(",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "WBC{j7GI30NC6]44oXl:",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "y@^})428-){~X!k$2TPK",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "kJsjB}fTFik@}d:dujyM",
      "name": "Map/Wave"
    },
    {
      "id": "`(/#(Q{vQdg*M@(hICzV",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "P@}v,/aVwwjl|YLzD`V`",
      "name": "Map/Wave/Step"
    },
    {
      "id": "N6ItAogtav^~0T~-kuU)",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "ybCxt}OKBkFoE*83#yk%",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": ",d6X=[3Mt|FcR+}ToMLZ",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "]P)@)q|75M5CaA=po|Yq",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "AN/_AVT8Zk9jS(rW)s?U",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "dWG3(a9Q8A?D/|2KnOD9",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "OaBQgm[;]s;C|-[+EA4T",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "ty6b8r86yV$tJ4_I_hh~",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "#Wj)b{,/%iX8c}O+%846",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "?qgSW6C;q_$wCtCx2PaE",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "]W:G~Wt5TU%8.$C_`DPv",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "!aA6[z3**c.er;-d{CEd",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "?cJRK@;y]5V=}da#t{ap",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "1TbOEbqnC4sy%[V~{pF-",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "xC/kB=^%i!e3b4p9q;D}",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "XdBN!~LvqDLHedl@BMXv",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "cAsI)S}37,I+6I!?3GIg",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "0Ra-!.+039hi9/)g1x69",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "|9mF3}f|Cc$KTZ9@f2V$",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "}+mEbf|n#/Y*v;p)8E??",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "%aD6j?c^;=Jn#TNh_^@x",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "$`!N`:8kO1w_zN9MDn`U",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "(045rfavtx{Vt/tJuR]B",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "c|rx8zir!SDWCwP9e%~f",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "m5Uj}@R0PLd#hFL=]3lo",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "%Ped;Fk9YehLaLz]}%H*",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "6Q{e!gszR[EGTpF@pVI}",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "baXWL_d$|!Cq/57Vg{EK",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "h94kvr=J(zph60NsU3Ur",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "B$XPd{-NwNff4S0Z7LUV",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "%ZYVXN^x5FY^$;QtHa1K",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "wHQ^C/Ev4)6AM)c]51vz",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "=Y)HGE=3xv|(.,b!L9s2",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "/y6YoWn^ro7xC2vuaAFv",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "mhRf.nS4BvHQ5/aIs1ny",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "9H1]|DV[fZ}T]J6t6ij8",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "nI)~ZnU/]_5R^L3}B-rK",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "k1R165^hJ|F*h3bN`.2|",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "AErq(D7~z~^`J1E7B*.R",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "RQpBHwqlAFE[jpd++/wu",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "O8k8z4f{8YJ/B=)Pb6dM",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "Qxro]q|DP9g}r[!UciqE",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "#%r%d}$MS#S_do(Lr}S*",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "@ztkyRnBLTr^Z!|N[0s0",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "LO)2,.WfoFm*JAnE`qnZ",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "AjCxd3UvM.[EI|kl:[oM",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "Z3@6zRB+U}}*Ep%W|T82",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "^A55ja$uCo2k5a/9i=:{",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "#:^o+3v$weK4_`r)nZIO",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "v*e_`?(:rF+Nf9pboGFk",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "UxAqW4tjsx%DLP;uU!@i",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "aA)5Wp#vw9;{k!wE+(A.",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "4(Q]h}x4v8({ii2K78~C",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "V^gZ|q5N4YVz?={}roeF",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "@~2jg8v+NJsy,56ULr)H",
      "name": "Gem shops"
    },
    {
      "id": "@%L0+rBA_e[1./SZY}qY",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "/lhzHM.fyEby*kH}#XWX",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "O:Nd_@,SolVyu|:JW2s{",
      "name": "Map/Wave/State"
    },
    {
      "id": "5{Ud^D?8#f3csXOMdX6t",
      "name": "Gem"
    },
    {
      "id": ",D1WRZO~9YGY=TY_~$p!",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "VyY!,Gx_^R4YBs4h/3Pq",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "z!8|)-8BZtr{ZVMGd6N[",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "N:^rtNn.(*eZN|RNw7#o",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "SK!0ap#o}HK9us+kskRt",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "(OK*0IIF9UsFz=QWf8xM",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "u~7E|O}-~A+Bh;4,GEYz",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "@cg]af@}j5h]Am=X.tw=",
      "name": "Map/IsStart"
    },
    {
      "id": "nJF6oIKKc??Sbv81`mmz",
      "name": "Map/CanStart"
    },
    {
      "id": "A9.[#GULd+S*Lt+dxl:K",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "|-S.B1dc+!U[dY%[%BRF",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "Ee+{]YD9RFtE2.,Y$oZ2",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "7OB!C#Yox-UMHkXyMqDv",
      "name": "Map/Player/Moving"
    },
    {
      "id": "Sg,_UPhwc]74)yI.1sM7",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "t1,SoPOYAlCTZCurf1Z~",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "N_J1nx(/19ta8nQEGxrc",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "9e(N7XY_.wG5(`rJrSYR",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "4pd=0eB5oB{J73elBBfu",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "5j(R=1!$(Y[WDmJhE;m#",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "7;ne@s$f/(d(gQpIP8rb",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "5Dk[F,6K$8#f#ei6+3OQ",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "sd${%v:@znbHW5h!ppBB",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "%5[[c!vmfNBd5V(^F-~v",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": ")Gr{wWg}{R-FqqPc;HFl",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "Xe:aSy`,oz$MioozdD[:",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": ",3sY=p@fLrX0/6}xS[=E",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "Nhn$Q8ErDEADu;f1;Cvi",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "f~t/I*W!QGvL.S{sgbpQ",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "]4`|D#SHwVJ?VQC0eo6-",
      "name": "@Map/Progress"
    },
    {
      "id": "+3WPc{eBRiI2EwZFF[%X",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "bKya{F_t[+u3A,;ir(.h",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "=nX)b1(b]rtX7QO]~|(V",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "#|xOQlucf1y@7W1l-JBg",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "3iKd0T11p+ZB5RhY1x9O",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "QCZ,s#+$[V[i*$uWU[s`",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "+KRsr.8-E78Ay1L/OXMf",
      "name": "@Skill/Variable/10"
    }
  ]
}