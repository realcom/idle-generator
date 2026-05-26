{
  "blocks": {
    "blocks": [
      {
        "id": "`Iuk]2vtQWs%xR5Nvdn6",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "NAME": ""
              },
              "id": "5+kH~;#S?VsDMlB@C)!/",
              "inputs": {
                "TEXT": {
                  "block": {
                    "fields": {
                      "TEXT": "must disappear"
                    },
                    "id": "kHKgUNB71U?A!pq;)1s|",
                    "type": "text"
                  }
                },
                "VAR": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "unitVariable:PositionX"
                    },
                    "id": "qvm@mz%@5C-Y3}~!F629",
                    "type": "variables_get_reserved"
                  }
                }
              },
              "next": {
                "block": {
                  "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                  "fields": {
                    "NAME": "unitMethod:Suicide",
                    "THIS": true
                  },
                  "id": "sWn1+$%jvhsrnlu|qt[E",
                  "type": "function_call"
                }
              },
              "type": "debug"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "LTE"
              },
              "id": "q9uN!d9.G?IX;bR0R8H!",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "unitVariable:PositionX"
                    },
                    "id": "BZ.uN+vrQR)QU5hQ_tKq",
                    "type": "variables_get_reserved"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "0/p4Ji:^+5VvKDcy9C-7",
                    "type": "math_number"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": 505,
        "y": -255
      },
      {
        "id": "ssS{)vRbyMT^+5;1E?,R",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "NAME": ""
              },
              "id": "~#d]R?EQXs=%1?bh6]#d",
              "inputs": {
                "TEXT": {
                  "block": {
                    "fields": {
                      "TEXT": "Unit_EncounterTrait_Update"
                    },
                    "id": "$n2bU}$oM_g}YvA_%LFL",
                    "type": "text"
                  }
                },
                "VAR": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "IV_x%YblHUCy.o]-7ADR"
                      }
                    },
                    "id": "Vcw?v,6#E1z;4@RBvMs.",
                    "type": "variables_get"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "TYPE": "board",
                    "VAR": {
                      "id": "e3*qr;.#[ebIUpGF~C{h"
                    }
                  },
                  "id": "C;#_v1fs!{ZQ]B;,wR4*",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "OP": "ADD"
                        },
                        "id": "X-a`iVnEb1q/uu-lyMNg",
                        "inputs": {
                          "A": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "e3*qr;.#[ebIUpGF~C{h"
                                }
                              },
                              "id": "Y}y__]KcmP0.=H13v,!0",
                              "type": "variables_get"
                            },
                            "shadow": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "F0CPFwEIzd+%TlEHwZ,:",
                              "type": "math_number"
                            }
                          },
                          "B": {
                            "shadow": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "V@4lI*7JE1lj-8$[UH(9",
                              "type": "math_number"
                            }
                          }
                        },
                        "type": "math_arithmetic"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "fields": {
                        "TYPE": "board",
                        "VAR": {
                          "id": "ghx4O)x]3f8T7]_h#FlB"
                        }
                      },
                      "id": "ab:VQ-SM$S~U_#B/y}xG",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "NUM": 0
                            },
                            "id": "4L3}~]C?o~a(:*HW|.uO",
                            "type": "math_number"
                          }
                        }
                      },
                      "next": {
                        "block": {
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": ",wOCY%(2F]4bR](Qn!S/"
                            }
                          },
                          "id": "!zMfN,.@f?.fShBjvvU$",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "s-,/Tk[ut*.=Sx7U#c?;",
                                "type": "math_number"
                              }
                            }
                          },
                          "next": {
                            "block": {
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": "IV_x%YblHUCy.o]-7ADR"
                                }
                              },
                              "id": "y=Z[043a^7t.i=-k1!dn",
                              "inputs": {
                                "VALUE": {
                                  "block": {
                                    "fields": {
                                      "NUM": 9
                                    },
                                    "id": "Os],MPLA2ZS,$*8Ns6zv",
                                    "type": "math_number"
                                  }
                                }
                              },
                              "next": {
                                "block": {
                                  "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                                  "fields": {
                                    "NAME": "boardMethod:ShowSelectTrait",
                                    "THIS": false
                                  },
                                  "id": "zKM;y?[2AE?=+uYL7uU%",
                                  "next": {
                                    "block": {
                                      "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;name&quot;:&quot;PlayerId&quot;}]\"></mutation>",
                                      "fields": {
                                        "NAME": "boardMethod:SendWaveStartedEvent",
                                        "THIS": false
                                      },
                                      "id": "a]_!N[$ghp@K`lvfRL:B",
                                      "type": "function_call"
                                    }
                                  },
                                  "type": "function_call"
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
                  "type": "variables_set"
                }
              },
              "type": "debug"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "AND"
              },
              "id": "!Ow7-M7c%G}YzuFA1lYN",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "z6-%(pyuS}dD?gzy)kRu",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "THIS": false,
                            "VAR": "boardVariable:Timer"
                          },
                          "id": "L+[)o[OUZ!Io:$M/+Tsw",
                          "type": "variables_get_reserved"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 0
                          },
                          "id": "n?Q60f,`;6FSpZ;j=8R%",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "logic_compare"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "OP": "EQ"
                    },
                    "id": "G`t)%-wduy=AHtO/XO[%",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "IV_x%YblHUCy.o]-7ADR"
                            }
                          },
                          "id": "uuh`;@$+9pmgI;iA#0xi",
                          "type": "variables_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 2
                          },
                          "id": "7]M3:YZ2Dl//-SXuuA~O",
                          "type": "math_number"
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
        "type": "controls_if",
        "x": 520,
        "y": -1022
      },
      {
        "fields": {
          "NAME": ""
        },
        "id": "PYdPz0+)iX)NFm){KqCO",
        "inputs": {
          "TEXT": {
            "block": {
              "fields": {
                "TEXT": "encoutnerstep"
              },
              "id": "LPITt/G=)6}7E?MmyN`I",
              "type": "text"
            }
          },
          "VAR": {
            "block": {
              "extraState": "<mutation></mutation>",
              "fields": {
                "TYPE": "board",
                "VAR": {
                  "id": "IV_x%YblHUCy.o]-7ADR"
                }
              },
              "id": "6Kjzm~NDRx$RMqM=$;Yp",
              "type": "variables_get"
            }
          }
        },
        "next": {
          "block": {
            "id": "qhXdN.44r^{OfqI|;TDy",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Position X (필수)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y (필수)&quot;,&quot;name&quot;:&quot;PositionY&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "unitMethod:SetMoveDestination",
                    "THIS": true
                  },
                  "id": ":64cm[:t5)wLR-9}@G5n",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "NUM": 0
                        },
                        "id": "Bu2Xqyxlo^@k+xOkrw6f",
                        "type": "math_number"
                      }
                    },
                    "ARG1": {
                      "block": {
                        "fields": {
                          "NUM": 2.7
                        },
                        "id": "0A_cZuN!8jG5@c,~b#TZ",
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
                  "id": "54;D76xGRs;(ur%eVfL,",
                  "inputs": {
                    "A": {
                      "block": {
                        "extraState": "<mutation></mutation>",
                        "fields": {
                          "TYPE": "board",
                          "VAR": {
                            "id": "IV_x%YblHUCy.o]-7ADR"
                          }
                        },
                        "id": "k3,:abKLF+fi/IfF_;Bx",
                        "type": "variables_get"
                      }
                    },
                    "B": {
                      "block": {
                        "fields": {
                          "NUM": 0
                        },
                        "id": "I%4Z8+tAKj1/;d_nsxkj",
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
        "type": "debug",
        "x": 505,
        "y": -595
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Unit_EncounterTrait_Update",
    "period": "15",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": "0vtS{}Oa;u|}KVKQ3j0m",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "zbRPIxw4aZhe@gLJDBA;",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "SW5ox^eOAf_aay}cCKv1",
      "name": "Unit/Time01"
    },
    {
      "id": "X)uL~^Q.]LAkJc8[bhim",
      "name": "Unit/Time02"
    },
    {
      "id": "%e#Vp7z{PYJSYtx;p:vo",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "QY6oKY:*I+0n|]htto|k",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "#_:_#l8jgnmFLyNOIX6[",
      "name": "Unit/MonsterID03"
    },
    {
      "id": ",U:xEsLd0B|IDy$s*]K^",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "+0VV$F{m0sPk6Mgh@v1%",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "S`^H+w=htHO[=PDM{;N#",
      "name": "Unit/Tick"
    },
    {
      "id": "Z@kv_#w7BHpnQ2=6@A]Z",
      "name": "Unit/Rome"
    },
    {
      "id": "fZ!FbTD`^X+jc]8|Rp%Y",
      "name": "@Unit/Delay"
    },
    {
      "id": "fbK1e1H`W3!vzpvU_xi~",
      "name": "@Unit/Range01"
    },
    {
      "id": "{B3.#Q~(X@,2e~+Nm)%}",
      "name": "@Unit/Range02"
    },
    {
      "id": "DO9S{0S;$mU.L4kj.]^j",
      "name": "@Unit/Range03"
    },
    {
      "id": ":g!MGp}|6Y[U;vlHxHp%",
      "name": "@Unit/Range04"
    },
    {
      "id": "(Vd:20@|ytwo;4?d+?O1",
      "name": "@Unit/Range05"
    },
    {
      "id": "GNKjsz0tnZUKaaZALQUf",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "..Hs8#u{VC~1uIiHX_=E",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "58mW[3*tOz^?^w_2Q%.v",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "yaA;~?s`9?e*z!?Gg?5%",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "S~=X|i2JtWna(_7ubn4+",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "c[[vuij-zs{cNwm@]{h#",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "JS)ZwPSa[0Re%O-[;34b",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "!y;)UkzJO]Ylgx76X+}p",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "_WGZ`6yf3{N-,7:~n`Q=",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "aW$mF8@b%1jD8tgg!rU.",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "{|5)vu@guVg:J|UJaRl;",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "`^Oc9EBOc=j]BtZfrN+G",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "!{HVzj*(ZOU,hb^ofY6N",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "YWp-ec3m/mRFa6B/}|n2",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "TI2b6^`j0m8lT@Tl;BJk",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "s$yS_`HPL1=C3)?eD3Td",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "-?;,fs;4`(;J2~ojB{Ou",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "r*k.IwW=uWZ17/,=YNfe",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "f`GTdiAI5EEfAg2~+dkx",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "_hJyisbFBz/(b^Dg:Wyn",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "KJ.%/j~`L?wQTO{I3]?m",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": "?kpO9;X|_A~fpjuY/fVb",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": ")zcd${p@W*xDD~t^sWUV",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "he792?dVo@6WmwfN%H`Y",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "K;@0[b-?~+{TyX@(2fVK",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "OBk[g4!CtJW.mlEF?+4Z",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "cURC+Gk88WinxagOLpU[",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "~KcUQQ=`UYix]@[1tu)o",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "o@W7o(?LjtLnlP:J?wi!",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "FbcfZA;Mqyy)z4We|F-m",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "dh7`xSSxxWU={-wRRLnv",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "rCJ5%05h*jPPC@.S[N/^",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "N$/Hb^IHkhf|:+~NA|Ij",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "~wcuOmqb%=)6/h}a1+(:",
      "name": "Map/BattleValue"
    },
    {
      "id": "*NXKhY=R+[]CQvZqxtj}",
      "name": "Map/IsClear"
    },
    {
      "id": "UpGrJEz1u{Pa9F}3oY(Y",
      "name": "Map/WaveCount"
    },
    {
      "id": "ofr;gCw8wf}Oer_UNX@T",
      "name": "Map/WaveTick"
    },
    {
      "id": "c3zKP^Z%js@c^;k!gs=+",
      "name": "Map/IsSpawn"
    },
    {
      "id": "HR5;K5L_DIz:J.Ik{~@n",
      "name": "Map/WaveStartTick"
    },
    {
      "id": ")n;8{}ZntaDRrE4yVJ}a",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "cTLzT=.r:,ql1xnT^~^A",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "l{ky/bOCAY[(z@d[aVgs",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "i6*V${9(`]wX?!]_:pAy",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "$AKQT;$s)=-K~k8~a-*D",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "a(vvj=P9O]YFogO-:7,-",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "8sB=~J}NM`?f%Xm:Gqt)",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "Lh;Ivd%7?4bQS[DHHVW.",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "L^Jgg3a:=;Cm!HPdhGAd",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "M9cgdDWiE}=`i7wb2VOc",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "z!vS~8Uz-2la!*3=x*;m",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "yt(b/QusDe$MR#y4Ac}T",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "vF.F313V}EYRTk~Ajbh6",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "YZB~Yv,|KlhQFsQR%+,q",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "u/(oY7ScYd{1LyGV%Pxh",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "[Lts/W+{UOm1ycd.Ou+#",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "8HqzlV%~MnAX;u{i*l7T",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "CH4v2$1~vh^ZHSULK~#u",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "V1eFY5@+)457}b9s1zVu",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "hVbJL#k5I`DiAu?r{{bG",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "Zf1~O`gAz$Py30kr7:,H",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "fI*^byyB,)9]N?lPeL5#",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "X5`*m0/2sHzGv7kwY#Rr",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "F/n];{zV/JDZJ;G!Eu.[",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "n%iA%Bcix-w/Y;SX-x.c",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "MD[F??f]:/UA.1u=WBxL",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "}4|`s$d]ku,Dw`A,P;*:",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "#vilaJ[U?v_d6oKOT6S%",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "[4iy6{U%(G]Kk!P3x(8=",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "(Olwt;^UfgM;Qc+YprjA",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "``fler2c4K,w~io5_[}N",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "jhst0Nr(1X;+SpiK-UhR",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "0f%,JBHGS_Tp5v9K-Vj`",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "de(~YULpI!/GnASlc;WT",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "Nrv%atx!)S]34`wK9!8v",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "sj%NH/x$szCN]yKd_8hE",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "FJg5|c|q@KAM_EQOZ2.o",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "Yj7`6^aHRlu.hV:-6`2w",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "20*8=KF%G=6c~GrD]*|b",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "ntq=@ma)t8VfwK#i2vN!",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "bgyk?HEDhYoB]Sp?bN/s",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "Ezh%fK_QrfWL`s_L@}wE",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "p~q%ZmggSWm`[zS;gr)+",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "+8vMYa8t+mw|T~Istm}p",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "P=RrfVkdweb|@mBUCIQ$",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "c?XCF?clS[R|Yn{Vz_5P",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "7KXi=U#c*?po9OWC?,Em",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": ";|#N?Bdzl]8)9vB;^UCG",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "S0CiIDdRo4W`N@0{a;5m",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "2EigY#Zgj)2K+)QpkF{n",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "IbE9^Q~(*Mvlx]z5`{l*",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "A@H]a=1-c*UY{BkddkSP",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "T0d6JU,+)Mqs!jCU;CwY",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": ".*2i|I4D$)L[rx#!PQg2",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "IHx(Psa{R__7@Yxcq[*k",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "MWevZmP5/06rT+,RLY4y",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "Qz9~NF+%mXAUzUi1sSr8",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "vraK^KZ9qMbQ)~DHyddL",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "t38t,ab[$cx!i-^}=?yx",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "0?,D5GD%4!N]W(Vs$7;5",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "ChuU113FV:{n{eQ2%2NK",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "`_DFM3o+o2(eEwqF0,:j",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "^$FtVM^=R[h|9_4_HsMe",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "|A9p,R!x1$!`^9$P6Vf|",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "5Jb,hG`Q{0B;Al9tbc@s",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": ")uaSh@Q]{S31}4u=91aR",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "CWfN|j0-[ZN,tVxYg3i~",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "1^@Q[Ezpg?yCli@lrctA",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "MESyM5P%i|z$up[?`9vI",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "x3jlNAoxjA_QUZyY%Gi]",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "j`6AW{Jh~]]^W+:=h@kn",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "8AuRwfW0~USA8{0B=jp6",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "b}c0.jF9z3TC*k:ugrmu",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "=qBB]HDfx{,I!6b,3FP;",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "6X4V@gC`bm~7~J_a0N^|",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "0SSOwf(PeO3b!MxrHp04",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "pjG2+1%7fCVff)MYjIei",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "l(g+9;Mp]$bj%~zh}B;K",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "/Ci@uT;SNBAmzn|cuQO$",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "T?ca{u:`4?h3|NI(fUw{",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "0vk`|$Z@kW;8$i#6l.j_",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "CcW:jeP/Qc%q!-c9p0nV",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "S!3Ltm==ND@Qxj;PagXY",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "z~TC%^Vx8YOVS:U%t3EA",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "U2*g470nW;M;*uRVrB4B",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "{seMPnzg/*Nd_p9;7c:u",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "au^R8(^prLXIaT0]I3iL",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "J,o0t].e7A!L[^vdkOdx",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "2me|:[rJb|aFW{Q^^ul$",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "H)QBEhATf88(#?od]i%Q",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "ke)3hIhbiN83=51:(QSp",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "i)h5;JOIc7+~K}MBs0:F",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "o~?R}*,gT3B[/^hNi[E*",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": ",iI8jVrajSs!gtHV4G|F",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "B)9Pj/q#(CNfQK]cUEof",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "H)ZU~fzR{StR%GK/.Z:D",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "Qi1BoxTK.JoeGJ{UWuUZ",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "=hX4LpdN1ed:Bs`!l*).",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "sH}]Ed/S{(xLugs@6lHX",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": ".f7}OFsfAs1YhtB2|A!T",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "=Rs34kfVuP-#`{0~aVam",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "|NiPnVrA_lGwT%?W?lH_",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "kj/WL~UKDU9JO.QpP%x7",
      "name": "@Map/Variable01"
    },
    {
      "id": "egNF]8F4C@.CXm-(J+lI",
      "name": "@Map/Variable02"
    },
    {
      "id": "Mdnpo/#RfrpDMw02H4[c",
      "name": "@Map/Variable03"
    },
    {
      "id": "!/^_auDWY$T)Qu`InB%G",
      "name": "@Map/Variable04"
    },
    {
      "id": "f=|P3+ID873n{5^?,J9W",
      "name": "@Map/Variable05"
    },
    {
      "id": "V)F[g8{wfQkZ:#/O(h.Q",
      "name": "@Unit/Variable01"
    },
    {
      "id": "#Q7oH[qez2CT8MNsD:Te",
      "name": "@Unit/Variable02"
    },
    {
      "id": ".ezIW1Wcd3[[W(KP}E,(",
      "name": "@Unit/Variable03"
    },
    {
      "id": "sAn-T_/i(4p=G-XwI!~t",
      "name": "@Unit/Variable04"
    },
    {
      "id": "qc(3jMd6#d;As}Ey$XXY",
      "name": "@Unit/Variable05"
    },
    {
      "id": "IV_x%YblHUCy.o]-7ADR",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "lr91)P#[I~FQ910n6F~Y",
      "name": "@Map/Encounter/Variable1"
    },
    {
      "id": "4ElnwS*wvWA[E@xS[bEC",
      "name": "@Map/Encounter/Variable2"
    },
    {
      "id": "S+;6T3X+$4-o3//bkD:c",
      "name": "@Map/Encounter/Variable3"
    },
    {
      "id": "snFKhAO;MrOY0*D2PBPU",
      "name": "@Map/Encounter/Variable4"
    },
    {
      "id": "!jVp[wAw:qbC(:R,B9xD",
      "name": "@Map/Encounter/Variable5"
    },
    {
      "id": "xW{Qt}HX8I!#5mXR{0D$",
      "name": "@Skill/Trait/BlastIncreaseKBPercent"
    },
    {
      "id": "xWa*mYoD;-UF_3%v1vHl",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "U!i1EDTTZY8*Yr*dW#2+",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "c_e)|qn/l|f2N+P2Ps#4",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "?z5FKeKLc=}%Uj^1]UP+",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "t~,e6bxCNER,%gyB#9~{",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "xGXDf~kxn4(rBhtP8zeJ",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "%?c*pIz=#Q6ZC]L.m,.b",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "+J*IU]/OSl5pLmPW53u(",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "cV*4aU`;*e.^!U-Hms.i",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "WDZ7X8EO4dLsI49UZ2+f",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "p?!d`$umc@Y21e67NP3+",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "8v1Hz1|1DVjZm@Ns;reY",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "HmT5sK~hq2j$U?57IJ]x",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "NGLv0Q?I_T{zZ[VwcHW*",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "MBT$yWIERd6q`CkWY!zE",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "a..IVq6@6y_|2S)VbXqo",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "}Qqj_71{^{b7yo3ISbgn",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "|:SBbM{qY=:!V_$mvORj",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "G0wU;{swsmYTXk#]Dg]U",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "KidMY^;4aukMzTz/C#C+",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "FrV*B[rafW(FnGEd}r}%",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "TM5uBH;MV*7!u,l{9:5z",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "]TqEkT|_|$z9_n^T[}qy",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "OJz.rZS9lJ]CXWw=(9V,",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "Q__mI}@2G{GXrgR.sptI",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "x-,`Aa@#)vXtIr0v0EDM",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "6kARt,63w@X)vJ-8s6Q*",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "[Trm9Cegk?#2c61?yjrC",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "SeAI:-%qU5YvOd]){_e:",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "cI^0yd!v8zV_FQqR%.!N",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": ".ioG$QLII#Em]T#/-7K}",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "#%?%!Di_k6=*KubM(^*{",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "@#o/r_7~(nB~iJRdv$YC",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "~?87-OrEOM6B3ZV,dG[s",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "nQQypiU^.0EP9%L]BlS}",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "y4/05c,d*s/q%2zFc6j/",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "U074b1612yYw6Z/,^U)4",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "{6~OP5aZB/JasT5u_.iq",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "vXyLb)fj5n$B%Jr@CwB?",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "*Lb7N~rJ`j,zQ:uSSq;?",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "/2;nZBE`:3Eqj-.g$set",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "SXs.D30s-Tg-fxPNjhkK",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "#}5n0.0YU5Vk!lzJ%,TI",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "s.}5)U*VLK0IGk7V3$Pm",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "CeCB7n!aRU]3(Qmm!o+%",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "*h/}BqJMpu~N4Jc9:@tp",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "48Y1b)X@(Ty*Y[ru*=/R",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "ueMpc)-b%ek~+zq?6tQb",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "T=#.NO.}J1}/8dyLoz#F",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "l]KuGvi*_;}yzJHl,E?5",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": ";1Din@|zZH{9va{0d6%I",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "gpnzur;5j|53Jor]``*h",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "zb?dMMa6-w#:1]]W5WE?",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "r];A6RVV;mmONmD:jW{e",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "9.(o~:ya|3pv-Bc31*[}",
      "name": "보석 상점"
    },
    {
      "id": "e3*qr;.#[ebIUpGF~C{h",
      "name": "Map/Wave"
    },
    {
      "id": "l[]lK+%0!!3Vm(SuR?dx",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "Czqt`3U:t2ExgAfF.|_V",
      "name": "Map/Wave/Step"
    },
    {
      "id": "3E4NJAyE)z4qBER;hVUy",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "@(bx:7AD-ef|O=C{*U!H",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": ",.OwRcXL02q)/UIuCO}1",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "ghx4O)x]3f8T7]_h#FlB",
      "name": "Map/Wave/State"
    },
    {
      "id": "H+{lwaTcSa2.pfT$PcaJ",
      "name": "Gem shops"
    },
    {
      "id": "rrw:)No?+hI~^1dWQlRi",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "i;Lz1Mqxw4K9dkSr|C2l",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "{2pGAU5Xyz98}-A?76`q",
      "name": "Zem"
    },
    {
      "id": "fOZj1J4L+2oBOJ6q(^gi",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "N*SqVPcf|TbW|lbR7iuy",
      "name": "Gem"
    },
    {
      "id": "m.};Jk5oHe-Wt?-K3+~M",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": ",wOCY%(2F]4bR](Qn!S/",
      "name": "Map/Player/Moving"
    },
    {
      "id": "HJPv8^{(aYqK(,kfV)Eh",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "1E3vKJ%2ryg(XjO{~%gi",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "xCi=PuG6v]C2Yb(tu./1",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "55s$Z7J8rF[Bu^,E*~$K",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "#WWraQXw(+umb?Z%!;2{",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "AJfRzJ8GKR6Z@*#9{KdL",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "BpyT2}R|Q7:Han~f}7#d",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "rAIABEFH/^Iao}#NO4f8",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "p,gL[oFqrdVqLgil}9TP",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "%cmSplDR7cA.g{1XXt7}",
      "name": "@Map/Progress"
    },
    {
      "id": "vd0*vgog7wh!XaoJjCxm",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "FK-q~SVnR1e,HklrR3}d",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "KOJ(VFJ3uNB0KDFD=y6G",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "`$92+e6W,;av[a2dWmPT",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "hbV$NBj6NHc.97Jwo/`7",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "O(Jj}=hP(tTdu@UQWFMH",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "qt@jA3ikLDh.e{@L~6,B",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "HdpY,(YL.8uV;S`K#~FA",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "kefpbQlR.p@=Ma#!zn`+",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "oa0Zu-4,h^22.KwoEjp_",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "o6`e0wE.5keJ/;K0ZU2V",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "M[IQ4?jr]hi09uhffEh:",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": ".oz6`7^HO5)HPqd@c1,u",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "Bdx@4U#Qao[O2gOr_Q1}",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "?Vl,WNVZ57jyWA6*_|0c",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "I6_xd0z43.+l~g:{$/tW",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "3HVJg7E${3r@PS@lr%,U",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "{3n68P:9vyz^aEA%,g1~",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "sC(|^*b;*4]C?J,^r`C~",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "nL/lXaZ?8?.*tLi^I/:X",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "6(SXcp0U0zj4wSm~0w.`",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "[W6Ym~/^_;N+_}Pv7xGx",
      "name": "Map/DisplayWinningTeam"
    }
  ]
}