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
                  "id": ";U|O/D[bqD==:3Q3]hxy"
                }
              },
              "id": "SwRjru(+Kj3C{_yto$Mn",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "8$UwX(pdCge,bIAPX57{",
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
                  "next": {
                    "block": {
                      "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                      "fields": {
                        "NAME": "unitMethod:LookAtTarget",
                        "THIS": true
                      },
                      "id": "q-XlssZSYsw5(#Rq|9:.",
                      "type": "function_call"
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
        "x": 425,
        "y": 575
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
                                              "id": "+)w/0e+4vVYqjNeFSGVP"
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
                            "ELSE": {
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
                                          "id": "+)w/0e+4vVYqjNeFSGVP"
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
                                "next": {
                                  "block": {
                                    "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                                    "fields": {
                                      "NAME": "unitMethod:Stop",
                                      "THIS": true
                                    },
                                    "id": "wA!Y]KP}X1K6^}ag]MC`",
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
                                          "id": "rraJDN[sS/`#2V?p(TLH"
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
                                  "id": ";U|O/D[bqD==:3Q3]hxy"
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
                                        "id": "]DX@p3.?^ohy!|Z$z:#H"
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
                                          "id": "#jE*?fqeH{pH;Zqk6]4)"
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
                      "NAME": "unitMethod:Stop",
                      "THIS": true
                    },
                    "id": "Q62*Ns:H?r(Z`=!q+m[B",
                    "next": {
                      "block": {
                        "fields": {
                          "TYPE": "caller",
                          "VAR": {
                            "id": ";U|O/D[bqD==:3Q3]hxy"
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
                              "id": ";U|O/D[bqD==:3Q3]hxy"
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
                              "id": "#jE*?fqeH{pH;Zqk6]4)"
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
                            "id": ";U|O/D[bqD==:3Q3]hxy"
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
                                  "id": "]DX@p3.?^ohy!|Z$z:#H"
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
                                    "id": "#jE*?fqeH{pH;Zqk6]4)"
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
                        "id": "Ic3pl7aBz;8v*^OBGIhV"
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
        "x": 415,
        "y": 785
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Unit_Boss_DegulRock_Update",
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
      "id": ";U|O/D[bqD==:3Q3]hxy",
      "name": "Unit/Time01"
    },
    {
      "id": "+oY/~*S#`W_aixAYhA=j",
      "name": "Unit/Time02"
    },
    {
      "id": "]DX@p3.?^ohy!|Z$z:#H",
      "name": "@Unit/Delay"
    },
    {
      "id": "?cSMH.XN`e1o{[vKzP%6",
      "name": "@Unit/Range"
    },
    {
      "id": "+)w/0e+4vVYqjNeFSGVP",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "oA/csyBHtKjY7T]Y|@2E",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "/-SAsTs_:e05,M-,n_rg",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "Lb92sPKoq_U*.cT*)a*.",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": ":g.S)~F[RZ234C}rJwi#",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "n3Shizb|SC{|L^ms1@f3",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "*OinMOLkJ6TN8BuHJ/rs",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "%ZAONRlj^-eSW=4/%FH!",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "rraJDN[sS/`#2V?p(TLH",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "aJ39wmiRQR^a/sHdAc_z",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "srdDJV6LYb.(%-cS3}TS",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": ".M`01CUEVYt?kXp#w?h^",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "yTV~v6qlSo@QI3uxdHj+",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "Ic3pl7aBz;8v*^OBGIhV",
      "name": "@Unit/Range01"
    },
    {
      "id": "4g7bv0bBfa:Ue$:tbb.W",
      "name": "@Unit/Range02"
    },
    {
      "id": "kgxC{3|$b`M3pK:a)XOa",
      "name": "@Unit/Range03"
    },
    {
      "id": "+ZyN@cUHYC0}O,Y7Jku?",
      "name": "@Unit/Range04"
    },
    {
      "id": "/Mw%Chpf{TZg[!+h=XN#",
      "name": "@Unit/Range05"
    },
    {
      "id": "G20z5w7lb|R*=n=cUHE:",
      "name": "@Map/MonsterID01"
    },
    {
      "id": "6Ki;*s/;8JgC_av?-IC+",
      "name": "@Map/MonsterID02"
    },
    {
      "id": ",vLk-r8aBpZp)%nA6c[E",
      "name": "@Map/MonsterID03"
    },
    {
      "id": "CLN++0:zVzxKJ$yEJsnW",
      "name": "@Map/MonsterID04"
    },
    {
      "id": "grB;(`97`VuH)qH!:ZBm",
      "name": "@Map/MonsterID05"
    },
    {
      "id": "$3PJ(gfMK.REfeIs{:xo",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "V%dTU/%Di_#YZ[WwNcvX",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "9A/|BmV1mY!Q|cj8~nFO",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "pB2;,iJ(v,=-?9yhoqKt",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "gzI6;ojW~]u_9p4/7])z",
      "name": "@Map/MonsterID06"
    },
    {
      "id": "DM0p%x@YQ*:(E2Goa@Ze",
      "name": "@Map/MonsterID07"
    },
    {
      "id": "4$;HLj#$]J@1BDNE!D9@",
      "name": "@Map/MonsterID08"
    },
    {
      "id": "=U%cNsBI]@AFv{ema8o`",
      "name": "@Map/MonsterID09"
    },
    {
      "id": "i^S]vpXQ)cOlb51VbbwD",
      "name": "@Map/MonsterID10"
    },
    {
      "id": "DJyMu_BzeVHWcfF,E0J%",
      "name": "@Map/MonsterID11"
    },
    {
      "id": "Fy5P2q-K%8Q,={X#ysXe",
      "name": "@Map/MonsterID12"
    },
    {
      "id": "d{3Ktzq^Mlo3!p1{Cx_-",
      "name": "@Map/MonsterID13"
    },
    {
      "id": "[wQguNYF`NL%:[x{5tx.",
      "name": "@Map/MonsterID14"
    },
    {
      "id": "Fh!od1Q%Nx33RYdWFo$J",
      "name": "@Map/MonsterID15"
    },
    {
      "id": "cr8@GG#.e(Q5~c39`OrH",
      "name": "@Map/MonsterID16"
    },
    {
      "id": "jEmnK1Az,!zi2wiC-fK(",
      "name": "@Map/MonsterID17"
    },
    {
      "id": "_T9c1yo%*BR-xRl91#ti",
      "name": "@Map/MonsterID18"
    },
    {
      "id": "iy%,$[ZKzEIRvE,FMS)$",
      "name": "@Map/MonsterID19"
    },
    {
      "id": "EidthNTNr!]S`J$yA-Y~",
      "name": "@Map/MonsterID20"
    },
    {
      "id": "H1%s*)Bj#BL@EebMAo*,",
      "name": "@Map/MonsterID21"
    },
    {
      "id": "8?GrJ.e.smC7*DdhA^vs",
      "name": "@Map/MonsterID22"
    },
    {
      "id": "~M2.KcF2Mxur!9VAt^A5",
      "name": "@Map/MonsterID23"
    },
    {
      "id": "V5d{ctHDu46]n-N$#(`S",
      "name": "@Map/MonsterID24"
    },
    {
      "id": "PEpw7(BJlPr=Ck0p{}uN",
      "name": "@Map/MonsterID25"
    },
    {
      "id": "SF-k[%,Q;4G(QDMldg#A",
      "name": "@Map/MonsterID26"
    },
    {
      "id": "9N2MbKjY+JmPwi5008,}",
      "name": "@Map/MonsterID27"
    },
    {
      "id": "?YvlxHDj!Q5Ax$=4W#9,",
      "name": "@Map/MonsterID28"
    },
    {
      "id": "b*|jJ@[Fk|(7HJJ80|--",
      "name": "@Map/MonsterID29"
    },
    {
      "id": "6dD|x?cao!0dxZ04N!qs",
      "name": "@Map/MonsterID30"
    },
    {
      "id": "CwD:my0GM`o)OGp;8l,9",
      "name": "@Map/MonsterID31"
    },
    {
      "id": "wO8*s2)xZg-P9;P,75Nd",
      "name": "@Map/MonsterID32"
    },
    {
      "id": "zRo]MHXQTiEfEJ@b8Uc!",
      "name": "@Map/MonsterID33"
    },
    {
      "id": "[RKOJd{i|[ra|%i2+rC*",
      "name": "@Map/MonsterID34"
    },
    {
      "id": "+wA}1c9U.*pLLL(P[*;J",
      "name": "@Map/MonsterID35"
    },
    {
      "id": "^HW3neVf_i}3wO;#F60Y",
      "name": "@Map/MonsterID36"
    },
    {
      "id": "|_Ld40h:5#2Mb4]$mwEO",
      "name": "@Map/MonsterID37"
    },
    {
      "id": "_cb$%1w.!Er]k!$=*dMc",
      "name": "@Map/MonsterID38"
    },
    {
      "id": "~iDPRj4I6u)(Dhe}co2Q",
      "name": "@Map/MonsterID39"
    },
    {
      "id": "p#OzA3]=yPuptG7k,eMp",
      "name": "@Map/MonsterID40"
    },
    {
      "id": "=,#/(QsepB?=yU]/vo%0",
      "name": "@Map/MonsterID41"
    },
    {
      "id": "UQ)%hdhbW,K%XnGflV{7",
      "name": "@Map/MonsterID42"
    },
    {
      "id": "xP3kD=umORTF]tsQj1fs",
      "name": "@Map/MonsterID43"
    },
    {
      "id": "Bq%Lf]AW:!$8r-f+(1MQ",
      "name": "@Map/MonsterID44"
    },
    {
      "id": "^pjR0TQ5Un`W/+?QscoT",
      "name": "@Map/MonsterID45"
    },
    {
      "id": "uNdSs9_~RJ2.(1_[%Jo+",
      "name": "@Map/MonsterID46"
    },
    {
      "id": "XM*l,$)Qm0(XHnuz{xQ0",
      "name": "@Map/MonsterID47"
    },
    {
      "id": "dcYJ`jH_;c}n|oG.`J{d",
      "name": "@Map/MonsterID48"
    },
    {
      "id": "o?7h[H=Vo-.?^SaK_9Qb",
      "name": "@Map/MonsterID49"
    },
    {
      "id": "a)OECy1E+}hp@*+]+@ky",
      "name": "@Map/MonsterID50"
    },
    {
      "id": "k.H%3ta08L;Z)K2{Nj0B",
      "name": "@Map/MonsterID51"
    },
    {
      "id": "[E~_w//I/l(V_$FNP~57",
      "name": "@Map/MonsterID52"
    },
    {
      "id": "(C836Rt|u6KZbV#@D=`/",
      "name": "@Map/MonsterID53"
    },
    {
      "id": "D{#?+]BQQ)h!1ok=()6d",
      "name": "@Map/MonsterID54"
    },
    {
      "id": "n[Sy:`}skJKTq|2f;2@s",
      "name": "@Map/MonsterID55"
    },
    {
      "id": "n:brPz=r3@g2oFTd=zMZ",
      "name": "@Map/MonsterID56"
    },
    {
      "id": "3,G_ockmfM~R@::c9%!#",
      "name": "@Map/MonsterID57"
    },
    {
      "id": "]|{9LYaSbh/5C|V7YTFv",
      "name": "@Map/MonsterID58"
    },
    {
      "id": "?G%7KIRoK]bw93m2lhJj",
      "name": "@Map/MonsterID59"
    },
    {
      "id": "J%j+P;=h#J2btR:l5_S$",
      "name": "@Map/MonsterID60"
    },
    {
      "id": "bFUW5K5Gd=%NwmY6;!/T",
      "name": "@Map/AddBuffID01"
    },
    {
      "id": "(_-*n]x^X=hD4j3xer(7",
      "name": "@Map/AddBuffID02"
    },
    {
      "id": "Tr*ZriYV0/y6$uPqaDWs",
      "name": "@Map/AddBuffID03"
    },
    {
      "id": "J^U:@a;|LwrNNPxbWuk?",
      "name": "@Map/AddBuffID04"
    },
    {
      "id": "F-#(XKoXusF?,8v9iH.$",
      "name": "@Map/AddBuffID05"
    },
    {
      "id": "9q6Lrz!%K4:l*nPvm2y?",
      "name": "@Map/AddBuffID06"
    },
    {
      "id": "BS|Qyg_%?IcMp=yo}9nc",
      "name": "@Map/AddBuffID07"
    },
    {
      "id": "O+w2jr60H{.nE_AMg)4b",
      "name": "@Map/AddBuffID08"
    },
    {
      "id": "$At@p/~T,--Ho8=x2f-4",
      "name": "@Map/AddBuffID09"
    },
    {
      "id": "O4UhsZIf^ud1R3Sx#G*s",
      "name": "@Map/AddBuffID10"
    },
    {
      "id": "Jt2XaUUd~%o1V15#iSzD",
      "name": "@Map/AddBuffID11"
    },
    {
      "id": "M9gBKL2|lJb?d]n85!r9",
      "name": "@Map/AddBuffID12"
    },
    {
      "id": "cF{(d$RSoWVVc52;)5{d",
      "name": "@Map/AddBuffID13"
    },
    {
      "id": "L@5yi,e-~:1@3Zb/?}%;",
      "name": "@Map/AddBuffID14"
    },
    {
      "id": "QvYZOcvm8G!o!0_cdbz3",
      "name": "@Map/AddBuffID15"
    },
    {
      "id": "-KpbqjRNVO|r2FX-L^}u",
      "name": "@Map/AddBuffID16"
    },
    {
      "id": "Un[0|np|[jq3{E=kg%UA",
      "name": "@Map/AddBuffID17"
    },
    {
      "id": "UjCPiqyA#)Fg}F(#i/]@",
      "name": "@Map/AddBuffID18"
    },
    {
      "id": "E33^Mir5:5a9lj%sq)wO",
      "name": "@Map/AddBuffID19"
    },
    {
      "id": "/AoXF7RL1v=/By`l2gl3",
      "name": "@Map/AddBuffID20"
    },
    {
      "id": ".c3Sb$?qxd=+jrUnfu_r",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "/{_gtF7BEX_{l;2}T=*@",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "SOX(z(gP_vLH-mdo28rf",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "Ej{jZ.7lrq,P8;Zwh$o,",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "eg8f/WUWq*^6sK7Yi_(Y",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "trCIJol~`%iSoo:%:iZr",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "^vrhUZ.zmgoL0tLi]-L}",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "VL_7:iTjf8/~)o(4np|f",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "Px}vwr6{l!75db|-?xl?",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "ZpFnL`vM6Pv*[62UJn(M",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "p[.=^=A$v=[5;s6tjqiO",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "4Q9U~yeBdLm.V{:cn]wk",
      "name": "Map/BattleValue"
    },
    {
      "id": "0]HoyD3]r4x,cYAwK`)8",
      "name": "Map/IsClear"
    },
    {
      "id": "eMz2t297Uf:Fr%+@UeR^",
      "name": "Map/WaveCount"
    },
    {
      "id": "U1u=OWS{/M)J$g%jtwEk",
      "name": "Map/WaveTick"
    },
    {
      "id": "0~J-/WR,D9#(x-:Ox%Ur",
      "name": "Map/IsSpawn"
    },
    {
      "id": "Ry%S0QhcQ9_n$hi(`,N2",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "/u=vmrfoy24;f/GVNEr)",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "nZshw/m#A6bO@nh`9DEH",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "Vol0FcyzkY3IH!jwm0Fl",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "zwKqqB.{ui~*MZ{8MqkK",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "ys{DOKHsM0R)h9wAon{Q",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "2xHRN4*l:{bSFt_4X,/B",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "/.:Oa?@+gWe;+ui=Y1ht",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "=mVA{Vz-rd5?jn]7/?;.",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "Qnu8iTGhQ`rFp93W-z05",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": ".G.94fa[Kd[d}c0?^27r",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "buV|$@EmT2}JGxQ!T!d!",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": ",LX{?Ci0z8.wq7(m;Nl5",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "+.8e`L=b}yAN!SJINn[F",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "5icscvf_R8ux`Q;FbCK^",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": ":YJ~gs7ki#c)E7Lk@g*U",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "(nJuw,i9qYVfVS?fs~!O",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "K*iNE;WY_d:lkkrXp0ZT",
      "name": "@Map/MonsterID61"
    },
    {
      "id": "g#n-S{_y*NEe?d0vUo-Q",
      "name": "@Map/MonsterID62"
    },
    {
      "id": "l8(#@Ca{;T^.4o~)+@+^",
      "name": "@Map/MonsterID63"
    },
    {
      "id": "YE.ek1OmI*L(6b:e=C-E",
      "name": "@Map/MonsterID64"
    },
    {
      "id": "jyp|^7V?sR6?X#T`uaN:",
      "name": "@Map/MonsterID65"
    },
    {
      "id": ")oj9C)azoMp[OXC{A-}-",
      "name": "@Map/MonsterID66"
    },
    {
      "id": ",du:~K7Is`j[s3GMHx,8",
      "name": "Gem shops"
    },
    {
      "id": "ED|f{*ci[8C)u.+=g;?]",
      "name": "@Unit/Variable01"
    },
    {
      "id": "%%}dt.v[atE|Q_NznJEa",
      "name": "@Unit/Variable02"
    },
    {
      "id": ",!^Pzg+TdyzmcwV{M_[^",
      "name": "@Unit/Variable03"
    },
    {
      "id": "_G%2G!OoFABA#d2j3q$%",
      "name": "@Unit/Variable04"
    },
    {
      "id": "!1]+Xvg1iXOVN3UP8^1i",
      "name": "@Unit/Variable05"
    },
    {
      "id": "jRf#6L^BM*I,t,0Azmm?",
      "name": "@Map/Variable01"
    },
    {
      "id": "^5wkmME)wF*P[6?h:_Pk",
      "name": "@Map/Variable02"
    },
    {
      "id": "1)2^4r-*Ne%s0lPj%Dg1",
      "name": "@Map/Variable03"
    },
    {
      "id": "3AZ$[B+x@,jv{hv8sBAE",
      "name": "@Map/Variable04"
    },
    {
      "id": "3(Sc1mI,mm58C`h/:n:z",
      "name": "@Map/Variable05"
    },
    {
      "id": "Un[KDYFL)b_eSu^{A|Q_",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": ".Pl4@.FKjA@n96V3WIBo",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "wu^7H1-bj4@@5:Lb{SkV",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "HHK|cx?bB;F|l}@KQ:c+",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "l:$)46UE!GsWvV80cwFF",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "5+wpq6]%|W1upex3O?Sa",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "[i{}yu0IXEs3t,Nzw{`x",
      "name": "Map/Wave"
    },
    {
      "id": "acbyL/O~bR36{df%4d!*",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "]zBocCWhf*?O`YkQrnuD",
      "name": "Map/Wave/Step"
    },
    {
      "id": ")RH3`.=Me9w,O5DtBV({",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "bI~JT#IcAT.`NL^42={y",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "3ynbV#5f56uyxl1zy%l|",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "^QI$jeiFA#`@FO45yz{w",
      "name": "Map/Wave/State"
    },
    {
      "id": "va8Irj;4`3vc4q{(1=QD",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "c`ga+]hS1WAT;8Oq1lAo",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "1dT}:ZqMTDk9+7_~XC0m",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "*dMioNKPu}+BaF#EpW|e",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "Uq^_5lsMRk+Oi$tzzZgr",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "F#F2/H_*RBor2:3r=JO`",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "EH?`ZEmH{D2-#GL$0lpH",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "M0YjV-P!A|6K^(j4T-?k",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "m81^ulpNn}7,)HH~CSd9",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "hswx`($SQPB2n6G;9(GA",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "M:e,emB8F3kBDY6tH+T_",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "$VlLjtR15*rvECz4CU$M",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "ERE-{ov|PO9An0!/j+4d",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "OVr:DNo{=OI?O1joYmE7",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "~nR]$s//4mP4G,6Bn8*5",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "**)cV3,XBJ-c%/!b8^:w",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "~Hq0_|07r2^)!Yld^,hV",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "pHuE6`Ob]cq]ur+$0`W=",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "Cv;lrs+$F[=fy);YzPb!",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "0p}`r}BGvtp!dUeV=,%x",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "DX}H9sGCwP@!vRqJgKx]",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "=U5V;Jr-2pY!6R,0et$/",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "uC43:%j43-7qU:2IeBWy",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "4aFaU~lA^:~vXhwVP,HJ",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "C+QC0TS3,/CV@[]@T`jp",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "qpq5]P*zN8/+b%e3a*Ct",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "zEU@]Uy,k%ZL4cB+zOLu",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "ERoIVDI2c#i7B]S0FY:m",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "hs~[]$;h3?Wok*Dj|lFm",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "MC4Oml4O(5,l!=3zWw3B",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "C4/{d:8hxK]iga(W(:.o",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "DNq/Sak@Ahg*6p4Z]c~(",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "olI?(.xeMb:|jTo]|ewo",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "4t_)#Tm`zbEAw=O@p*_t",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "J63M,/q2EqSI)|2$$.nl",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "tEy,!.Mo=0pL6XRLU~?s",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "xeoMrD)7T,@dLKD%;EUo",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "hp9oKJ2j[Ua-:QWs@dg-",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "*Hj4ZQ|QLfSv+Zy7o-,7",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "JALC90+[$`*}k~1~6;Ov",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "+tII7T*SSav{#sBO$0l:",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "+k#v(}4Yld-GBXR0af/v",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "%[7$Sj,sl|cCA7|!XOw?",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "jB.b#Jbgagd@2_xg[fQR",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "qqOJe^olL.}uN}Z3^jn.",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "P$/Lg62BBF]q^b|q*T0e",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "ABgy)pwdxGwdJen3wjc~",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "jpk9rT[xZo8[8e]6jRM6",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "P*~h2x$H,SW(YIlipw#+",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": ",LQRoO@.icVt?2|b|x3_",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "L!g/#3q`9-o3itMRJ-}L",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "w-g1+=nWVo2xNGgzZjI!",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "w;koAdC$_X+%.GvNQ16P",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "SLx0mKT69`UKtl}yK)p.",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "]|f7SMO*wdEtiU*Ay;S$",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "3yy{r(#E%N1[?}[7`C-}",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "/.1f(=gFQ6XdOW~Ct?l]",
      "name": "Gem"
    },
    {
      "id": "-xS]#k/}SwfC!uO%yj}h",
      "name": "Map/IsStart"
    },
    {
      "id": "4ED-*U=k~B7~5AD!mZ.L",
      "name": "Map/CanStart"
    },
    {
      "id": "cdtl%HKMNG4*]{Ljh6VI",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "vfC[)C}=4U497Gk0|moN",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "SkAjLJ^~YBm`$3g`Qq?K",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "9csqY_vQ7l@Kb}o_$DP,",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "d`b0)=zhuugZ^)Fw)^j:",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "w-zPXHc(F9qB]hdMNYbt",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "Ew`O`$$[t0,_}(^-77!,",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "#jE*?fqeH{pH;Zqk6]4)",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "jjZBsFop2ABJ=GHX1l6s",
      "name": "Map/Player/Moving"
    }
  ]
}