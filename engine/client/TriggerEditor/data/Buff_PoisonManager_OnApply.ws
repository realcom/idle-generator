{
  "blocks": {
    "blocks": [
      {
        "fields": {
          "TEXT": "기본"
        },
        "id": "_tt=6^mFjyxwxox}4W4R",
        "type": "text",
        "x": -695,
        "y": -775
      },
      {
        "id": "+jqs67F2Cg|wt%h2@4@@",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": {
                "hasElse": true
              },
              "id": "DZ$lnUqbIaE0$~qUr8~t",
              "inputs": {
                "DO0": {
                  "block": {
                    "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
                    "fields": {
                      "NAME": "unitMethod:RemoveBuff",
                      "THIS": true
                    },
                    "id": "XIY|4yplKW+Vj9C5R0mT",
                    "inputs": {
                      "ARG0": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "caller",
                            "VAR": {
                              "id": "GnM3@ta4/rwB$nm0{^|:"
                            }
                          },
                          "id": "IWZgp7e?fK(voJg-L[lB",
                          "type": "variables_get"
                        }
                      }
                    },
                    "next": {
                      "block": {
                        "extraState": "<mutation itemCount=\"4\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration&quot;,&quot;name&quot;:&quot;Duration&quot;},{&quot;comment&quot;:&quot;Sender(1: attacker, 기본: 현 유닛)&quot;,&quot;name&quot;:&quot;Offset&quot;}]\"></mutation>",
                        "fields": {
                          "NAME": "buffMethod:AddBuffToOwner",
                          "THIS": true
                        },
                        "id": "4Zwv_2qP(x~N~36L6znG",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "caller",
                                "VAR": {
                                  "id": "DlB,G5#JNknh5e%,^Q4`"
                                }
                              },
                              "id": "#lgwR/!t7W@:[7.6ZelH",
                              "type": "variables_get"
                            }
                          },
                          "ARG1": {
                            "block": {
                              "fields": {
                                "THIS": false,
                                "VAR": "buffVariable:Level"
                              },
                              "id": "9~uE0oxtVT0tE+),RKKC",
                              "type": "variables_get_reserved"
                            }
                          },
                          "ARG3": {
                            "block": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "hGNX^[f0[-$t?EDoF7Hq",
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
                "ELSE": {
                  "block": {
                    "extraState": "<mutation itemCount=\"4\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration&quot;,&quot;name&quot;:&quot;Duration&quot;},{&quot;comment&quot;:&quot;Sender(1: attacker, 기본: 현 유닛)&quot;,&quot;name&quot;:&quot;Offset&quot;}]\"></mutation>",
                    "fields": {
                      "NAME": "buffMethod:AddBuffToOwner",
                      "THIS": true
                    },
                    "id": "g=g=f~CBm-hdlHIXYNBA",
                    "inputs": {
                      "ARG0": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "caller",
                            "VAR": {
                              "id": "GnM3@ta4/rwB$nm0{^|:"
                            }
                          },
                          "id": "u+ETnux,^:UJDr{n=(#2",
                          "type": "variables_get"
                        }
                      },
                      "ARG1": {
                        "block": {
                          "fields": {
                            "THIS": false,
                            "VAR": "buffVariable:Level"
                          },
                          "id": "G+vEYN=foL(?5=3FF:58",
                          "type": "variables_get_reserved"
                        }
                      },
                      "ARG3": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "eiiR.a9ybsq85K=A-XM[",
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
                      "OP": "AND"
                    },
                    "id": "v~bn.:h}w1.+DGoKG0fy",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
                          "fields": {
                            "NAME": "unitMethod:IsBuffApplied",
                            "THIS": false
                          },
                          "id": "+|:ANU8vaH_=03~N[6YB",
                          "inputs": {
                            "ARG0": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "caller",
                                  "VAR": {
                                    "id": "#1O}W=;9,6)@KlDQ.V!o"
                                  }
                                },
                                "id": "22%C;$#/WYG~?TtXBP]g",
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
                            "OP": "GTE"
                          },
                          "id": "OuWOWiY$lUosuL9Dz~#C",
                          "inputs": {
                            "A": {
                              "block": {
                                "fields": {
                                  "THIS": true,
                                  "VAR": "buffVariable:Level"
                                },
                                "id": "[k}k].86R$!mF`+w*`{T",
                                "type": "variables_get_reserved"
                              }
                            },
                            "B": {
                              "block": {
                                "fields": {
                                  "THIS": true,
                                  "VAR": "buffVariable:MaxLevel"
                                },
                                "id": "Luxs5d-[B{j?!bxLJ#S5",
                                "type": "variables_get_reserved"
                              }
                            }
                          },
                          "type": "logic_compare"
                        }
                      }
                    },
                    "type": "logic_operation"
                  }
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
              "id": "qsMdoc.yji?9sh4==3U{",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "buffVariable:DataId"
                    },
                    "id": "Qeb~NED@}FEVy*#~,IrW",
                    "type": "variables_get_reserved"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "THIS": false,
                      "VAR": "buffVariable:DataId"
                    },
                    "id": "X5/4+|}|$@,R*^VZ[{5I",
                    "type": "variables_get_reserved"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": -677,
        "y": -487
      },
      {
        "fields": {
          "TEXT": "기본 & 치사량"
        },
        "id": "@X!EqL^.79f#[pFKwltv",
        "type": "text",
        "x": -665,
        "y": -565
      },
      {
        "fields": {
          "TEXT": "20120251(공격력감소)"
        },
        "id": "{1Gorr)1BGj3!E;$hnY_",
        "type": "text",
        "x": -695,
        "y": 95
      },
      {
        "id": "ju9,%S`}e0Ak30Tf{r-_",
        "inputs": {
          "DO0": {
            "block": {
              "id": "$@eoA8m_~CQLB9zzw(ek",
              "inputs": {
                "DO0": {
                  "block": {
                    "extraState": "<mutation itemCount=\"4\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration&quot;,&quot;name&quot;:&quot;Duration&quot;},{&quot;comment&quot;:&quot;Sender(1: attacker, 기본: 현 유닛)&quot;,&quot;name&quot;:&quot;Offset&quot;}]\"></mutation>",
                    "fields": {
                      "NAME": "buffMethod:AddBuffToOwner",
                      "THIS": true
                    },
                    "id": "{)_M@jOjy{LT*x[L.!_%",
                    "inputs": {
                      "ARG0": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "caller",
                            "VAR": {
                              "id": "$o.-fLu,;WD@JxAY@2:d"
                            }
                          },
                          "id": "5`$JUDei5^Gi_^d({9~0",
                          "type": "variables_get"
                        }
                      },
                      "ARG3": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "lmH[vN/XLuD|KCdE=1b|",
                          "type": "math_number"
                        }
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
                      "THIS": false
                    },
                    "id": ".)_ymf+HL39#u~,(R6nf",
                    "inputs": {
                      "ARG0": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "caller",
                            "VAR": {
                              "id": "!vyu#qg|N0+gn)WAJvYr"
                            }
                          },
                          "id": "kFbcqTZT;4SX+C7vo}qq",
                          "type": "variables_get"
                        }
                      }
                    },
                    "type": "function_call_return"
                  }
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
              "id": "b`+%h_!A6pGhthO+92_W",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "buffVariable:DataId"
                    },
                    "id": "gXed)kt3N}rxjP6O4,C,",
                    "type": "variables_get_reserved"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "THIS": false,
                      "VAR": "buffVariable:DataId"
                    },
                    "id": "G6n2|o;A87f_6HT/0jOX",
                    "type": "variables_get_reserved"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": -685,
        "y": 175
      },
      {
        "id": "UcOmTeU0nxqkpITKD=@g",
        "inputs": {
          "DO0": {
            "block": {
              "id": "4KtsUV2sewE.;XMz6,ep",
              "inputs": {
                "DO0": {
                  "block": {
                    "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                    "fields": {
                      "NAME": "unitMethod:AddBuff",
                      "THIS": true
                    },
                    "id": "UW|/k6p{|a({C~4xl)eH",
                    "inputs": {
                      "ARG0": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "caller",
                            "VAR": {
                              "id": "D${-al{~RAMB8JO/2tHt"
                            }
                          },
                          "id": "3b9MZ1.teai(8d$b.6a*",
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
                      "OP": "EQ"
                    },
                    "id": "5!Xf.6Sd;BTae`#,1@|B",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
                          "fields": {
                            "NAME": "unitMethod:IsBuffApplied",
                            "THIS": false
                          },
                          "id": "cl%`RVCb-ZFsZm4pI$7d",
                          "inputs": {
                            "ARG0": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "caller",
                                  "VAR": {
                                    "id": "5n{,9;AJaA;q0tfdj=YP"
                                  }
                                },
                                "id": "kqOW5Q*#+=3+]Jbu@u/U",
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
                            "BOOL": "TRUE"
                          },
                          "id": "qpc}Nl}E~}eqzz#^^Y/,",
                          "type": "logic_boolean"
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
                "OP": "EQ"
              },
              "id": "Y:N1.pp=lQD(-02?_-92",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "buffVariable:DataId"
                    },
                    "id": "YrkmOex^]*mFy5t0sxlg",
                    "type": "variables_get_reserved"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "THIS": false,
                      "VAR": "buffVariable:DataId"
                    },
                    "id": "sue%?^z3+06^W;g*4;Ms",
                    "type": "variables_get_reserved"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": -695,
        "y": 555
      },
      {
        "fields": {
          "TEXT": "중독 슬로우"
        },
        "id": "vU!?UTup#@3Jtwgkg{$K",
        "type": "text",
        "x": -695,
        "y": 495
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Buff_PoisonManager_OnApply",
    "period": "0",
    "triggerType": "10"
  },
  "scroll": {},
  "variables": [
    {
      "id": "9WzJ5@NHjAa*~bkjOz=-",
      "name": "Gem"
    },
    {
      "id": "zZ)Zuz9ul*`t(H0b+E%X",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "G$qW{:QMpC8bqUk6Iq*x",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "QAJ(W-Run-uMuAovF{rR",
      "name": "Unit/Time01"
    },
    {
      "id": "kBcm}S)@-[{FT%lsn1LR",
      "name": "Unit/Time02"
    },
    {
      "id": "[4|Nga[73D}F5XDS7Xys",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "j!0)eA:+--wp-;N^Q`3!",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "pRl)EoXPx!6Ah*:P,%m{",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "Y])F}7o]*|?l_yKDeu4p",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "S|{$CyIGH!8zIn2N;xgq",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "sL-voSORuV:i%]slna@P",
      "name": "Unit/Tick"
    },
    {
      "id": "F:/BFhfFawiNDGn1uCKV",
      "name": "Unit/Rome"
    },
    {
      "id": "V/4gf-n%0NI,4AQdu+,[",
      "name": "@Unit/Delay"
    },
    {
      "id": "/.-k2S$F@@2gTIqZ37^*",
      "name": "@Unit/Range01"
    },
    {
      "id": "$ire4ERnx$[bhFM@sxQw",
      "name": "@Unit/Range02"
    },
    {
      "id": "JY]l;KO#I`Z-1Bz/v.R4",
      "name": "@Unit/Range03"
    },
    {
      "id": "P16H61di0o*w2@IH:I5U",
      "name": "@Unit/Range04"
    },
    {
      "id": "8T}qgFuWmwJy@VG-Ppga",
      "name": "@Unit/Range05"
    },
    {
      "id": "jF:@;.p0{_H76,Mamx|-",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": ";,!I+oVjMYZD{[8Iw@ev",
      "name": "@Unit/Variable01"
    },
    {
      "id": "zIN_a[bR}Ho|it.j#$b9",
      "name": "@Unit/Variable02"
    },
    {
      "id": "]VX5@-hnRP4e8+iVC4mr",
      "name": "@Unit/Variable03"
    },
    {
      "id": "31WYceblQ!Bv%$~bdRJ%",
      "name": "@Unit/Variable04"
    },
    {
      "id": "jGjuc~eCz.w4ZeZ7c-YQ",
      "name": "@Unit/Variable05"
    },
    {
      "id": "m})y_gkz8^TYNCq}9jqg",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "Z^n.:x#oiMy2a2|`4G~Y",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "RE#x.ot6PliMvzmlJRpV",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "EN*hm6-uOXV/9Gz3S24@",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "Gb!=wNc54XzDO6#VX?l!",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "qfyn+wo2!w#]1_GONea4",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "fZH.!e25:ArSAa+@SbX6",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "JfLdbzltWArY)1^fJ])j",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "~$A}Yo5VN?QP#{KEGZx_",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "HYtYnL^5U:)-N(C6$L8#",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "Ti[oHh`9stZ-RVs:yXu#",
      "name": "@Map/Variable01"
    },
    {
      "id": "-5Cyfy1|[.c}7(s_wMW;",
      "name": "@Map/Variable02"
    },
    {
      "id": "oM|$C]i]52^D(pMn+lyx",
      "name": "@Map/Variable03"
    },
    {
      "id": "@;ai7(w?,?xAe}-y##W9",
      "name": "@Map/Variable04"
    },
    {
      "id": "RY;o{?1)chbHa,Ny{)#)",
      "name": "@Map/Variable05"
    },
    {
      "id": "z0#XZy#n(3-K4}^#!pgk",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "!fz{1_ht7g24K-/4?wFc",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "?rSq59Jd)i14z7([DS!c",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": ";o*KgO;10ODN}=TGMik#",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "#ua$e88Pr$^f?K;~;1!?",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "^`A=1SjP.NK(~f19@8^6",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "J]XlTd|mc~I}3{wyB8~!",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "c(p,AGYV_N{hRv*Ju%%a",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "OLX.Rx=?skzQN|jk?]F=",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "5.60w7)Z(ypu.r:yNSD;",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "Sb{q{D;z=t:uWx]}eC[/",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "mHUn4LoD4^pHqm7LSXEz",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "pR:Ecfnn.BKh_)Wws0am",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "k4~7Pe7mX+vrdI?f9~75",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": ",3Hi~ZbV3)DlL}[d*TCE",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "^mU.Av-v@$+!`Ec)JwR!",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "cT+0u;!FaY?wxlP}:9l7",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "/1k74;=dt#,AE@(.y4Y-",
      "name": "Map/Wave"
    },
    {
      "id": "eYu-:_x]MLpN~C?lN/lG",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "nd=U7H8K2HaMGd1.V#8|",
      "name": "Map/IsClear"
    },
    {
      "id": "8=FSRm`P7#/9(n~H(jL0",
      "name": "Map/Wave/Step"
    },
    {
      "id": "YEs.oOpe%WIA?lGwc6=V",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "EQWm7YopTGcm5i(b[MkT",
      "name": "Map/IsSpawn"
    },
    {
      "id": "yH2LjD}d{Fe.hqWw1B/f",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "QMTTDl]H,ii`Kn0i|Kux",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "-Lb=gC[OP)q4KAlrA_;5",
      "name": "Map/Wave/State"
    },
    {
      "id": "3oxsQZiOa=?$[ab==m!M",
      "name": "Map/Player/Moving"
    },
    {
      "id": "GnM3@ta4/rwB$nm0{^|:",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "DlB,G5#JNknh5e%,^Q4`",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "#1O}W=;9,6)@KlDQ.V!o",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "!vyu#qg|N0+gn)WAJvYr",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "$o.-fLu,;WD@JxAY@2:d",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "5n{,9;AJaA;q0tfdj=YP",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "rSsnBM{(5eE#sL#]Ld01",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "`,eYc%Xi7YG;pbkuG0*o",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "wzN7+{;RPS$Vdk(;k]qq",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": ":829`~wV,;=vcUP9iMCE",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "%ol.(VeE8-c-`*CP^VL^",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "3-7-tZ@Gj(w$gD/-dwzU",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "3C9RsEq9tra02kLRmbQ6",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "MWXZ:/|hO|T;{,s~Xr//",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "CC`)UB8W|7(#bDRTnjX%",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "bly$sd/?X0eg)S7,6j}v",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "t2_J-SdSBKQ0`_e:aZ`s",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "2/uA$de%+t^Jx5@._}A4",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "3JY-Bsa+jou;0+V4PqYK",
      "name": "@Skill/Variable/02"
    },
    {
      "id": ",$ix![PhyV5/0sq=~_T[",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "0gE,m6id`a34Kn!x*?qw",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "8qf`6}E3lfVnd9sS7,Pz",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "hJ|SVO(+E}fM!+VOfv?2",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "6rU;NQ3r0ZJ+/L-^:M#:",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "9)evUHpU8jLe*#P+[(,U",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "mBrQ90KjK9;k6HgFpD)L",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "V-ZHiI7%d_IW}0hnt.G6",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "mxZRnD/^KW|:%5rQbpol",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "7r0BO1q{Zt?|vkHc={Op",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "Uzl#*p270rmhaYuV{@$=",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "Xt+wJy?y6gW6=vjAGOp3",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "-!yq!`t!5gOKj;y=kzL7",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "*,o7.B=/wJ[YkQ}.x$SS",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "@F.U[E*Co;9PBLlIkeq[",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "t-%.6}%caP5+g*zhS8`S",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "YvV@_JOn;$yB,$%_}Bxv",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "bPH^rdEXTun#OX3rHC;$",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "[xDDq[;8e3tcA8|^;#h?",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "]`V[K5RS4@%V=+!FrPw~",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "xUs,x,oa]Qm)Ty_4a0cj",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "Fh!5U^6(VM}c=Vc;-`4i",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "u~kE7^:2KfO$qKI1Q/99",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "(:i9`]Qhazbnc3`mRYrr",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "-Ku=`GoqGcd^V.AqgzT|",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "6]GHL?y6$=Ov-ONrK`09",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "nAb!]ufj#F/?!Z!p#X4E",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": ".e#gRLYg:K{)|/]@0CcP",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "7wo/PDysOu}ZIOKBA^zu",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "w^!,6.s:bUL$@2r_aPy@",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "||3SHQms6niS2/H%sWh#",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "A^ID}F^9Yz-Jv=.w?a%p",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "?a=UyF`hJXNn?uwa8*CO",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "Y{+|V[GQO?DQ4oglb8sk",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": ";{BGoT#Ia^]#Szj1vEZE",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "dVd|T/h#cB(,z^vJ0r_V",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "AzylX4XM9smbeg)S+yJ!",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": ",NEG{Zn5=!61Vou|zjXT",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "`_~;qwASKvCxXIT4V5b^",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "HoB9^6e1x#`xqN@S46?U",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "G~)HkSJ.}S_U$kr7(w6f",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "CzQ}Q^9$w]PGUkrt6CoH",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": ",|Z`u!QQuzhsTJ!$%HSQ",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "WH6CaE;B[_`Lp^VL1?ak",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "JyC!Lb?,Sx_@Y2kC}.uG",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "+ppOYwVE@Y}$SsQfRuiK",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "SK3T_8%r-6FAhB9zRaXT",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": ":R#s$o}kCa7,hn|kjAU-",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "#;]$i49+{.z00)~dL7O@",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "5;g/$X?pC_T`#Vff7^vh",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "xbf$z,xAJwTYrm7L_saF",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "=.SWGhv7W%%VGoTkaymK",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": ",SDa/AiK{AL3FLJGe8X4",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "s*0XQA8H4Ra*r:eB;!rj",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "dV4qi}=vVfXKfg~!T-jY",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "Qp{uV+X8$f6`xnb!lG.;",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "O%~0o#PPU=qHypPIZ$X@",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "N#LOAZfy?7o3.4!D)lHD",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "rT@VA:~M9C_Jy`?se3h/",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "Ze`Qf#kK(Uq7X*l@y!Jq",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "@X.{~CG~UA~{smuX!3gX",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "D${-al{~RAMB8JO/2tHt",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "km,t1[$]?Sf;/AHhzY`o",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "`dAx:X2%JWICF_Px-j(S",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "o%M7UQ+6Pns7N*~sUmo0",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "=Snl..pxn#u%r9r@ywwc",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "Lk`vQ!5)R|w]eP+T.f|/",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "oFx!t82)j^V)AD_$W.N/",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "0{|{h@]LwxBK./W;l0ri",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": ";7|[~`l|dl8|WVVupYIy",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "wQ?y}BY%XlNL~`^b%Zy;",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "yRWLFT_FS:4wH%lny1Rt",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "J%R,#g@0AzE5f),??0u1",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "_?9gQ?,8XKUVCsg7s:RB",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "ttu/^72~lOZZHL?:GuY#",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "*Q2lam2mJGGn{u3}WLew",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "`WRm{LWPm)ncl22lcaii",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "dJ4h,3)3lD)hK7uosu%,",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "ly$i(QriH?83Zzq3(D4}",
      "name": "@Map/Progress"
    },
    {
      "id": "QY3CQ`d04wt(!*8!rxLC",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "-B=cE{h`S~l-96zJ{K+6",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "{XWF%oj8@_4C$cw7I=^z",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "]{#AbJ?`$VAsW-5_;J[9",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "t,gSu_,]bzprMC{yytuK",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "AdRw}*^1UMp+HW+i;z`.",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "RVJ?WPV.g)h~2T|BLkfs",
      "name": "@Skill/Variable/10"
    }
  ]
}