{
  "blocks": {
    "blocks": [
      {
        "extraState": {
          "hasElse": true
        },
        "id": "XY-96)%0aV[0S}%(giA$",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"5\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;DirectionX (default = unit X)&quot;,&quot;name&quot;:&quot;DirectionX&quot;},{&quot;comment&quot;:&quot;DirectionY (default = unit Y)&quot;,&quot;name&quot;:&quot;DirectionY&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:UseSkill",
                "THIS": true
              },
              "id": "I4ReeI*4rQ5|*s]0J8{6",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "AriHak)B13ENp?_v77}3"
                      }
                    },
                    "id": "n]G[79|#ZCV//-O=@`)~",
                    "type": "variables_get"
                  }
                }
              },
              "type": "function_call"
            }
          },
          "ELSE": {
            "block": {
              "id": "=W8xJX!%lM;[J)}m%=o!",
              "inputs": {
                "DO0": {
                  "block": {
                    "extraState": "<mutation itemCount=\"5\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;DirectionX (default = unit X)&quot;,&quot;name&quot;:&quot;DirectionX&quot;},{&quot;comment&quot;:&quot;DirectionY (default = unit Y)&quot;,&quot;name&quot;:&quot;DirectionY&quot;}]\"></mutation>",
                    "fields": {
                      "NAME": "unitMethod:UseSkill",
                      "THIS": true
                    },
                    "id": "JKe=+-)?.}:1v}B+/X]1",
                    "inputs": {
                      "ARG0": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "caller",
                            "VAR": {
                              "id": "v97wNEAKQB+CEhD%{V.J"
                            }
                          },
                          "id": "MB8gD8Ot^R5sR*,gman(",
                          "type": "variables_get"
                        }
                      }
                    },
                    "next": {
                      "block": {
                        "fields": {
                          "TYPE": "caller",
                          "VAR": {
                            "id": "}rmh$SU(#@=uzbdUB|Yw"
                          }
                        },
                        "id": "=cI3MJk5Fs+|Ap|BCXo[",
                        "inputs": {
                          "VALUE": {
                            "block": {
                              "fields": {
                                "THIS": false,
                                "VAR": "unitVariable:FreeRollCount"
                              },
                              "id": ".SWN-Txd!^}gq;*i8/M+",
                              "type": "variables_get_reserved"
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
                      "OP": "LTE"
                    },
                    "id": "ob7#}q4k-1Jb^?N!m`.U",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "THIS": false,
                            "VAR": "unitVariable:FreeRollCount"
                          },
                          "id": "pJyleQQ!`4_4AR%c!gk!",
                          "type": "variables_get_reserved"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "OP": "MINUS"
                          },
                          "id": "./tYI#F8/Llonv}i[eo:",
                          "inputs": {
                            "A": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "caller",
                                  "VAR": {
                                    "id": "}rmh$SU(#@=uzbdUB|Yw"
                                  }
                                },
                                "id": "4nT5w=4~JBL%9_lqlKCc",
                                "type": "variables_get"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "4dKrvAHGgg?jGCD:j3Gr",
                                "type": "math_number"
                              }
                            },
                            "B": {
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "%*IGgJE)Otk.Dl4W(:nY",
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
          "IF0": {
            "block": {
              "fields": {
                "OP": "EQ"
              },
              "id": "L7G9n@5@o)CW4U3|2%b.",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "THIS": false,
                      "VAR": "unitVariable:FreeRollCount"
                    },
                    "id": "CpQs5,bkI#WnVHqacTZ~",
                    "type": "variables_get_reserved"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "ejyXZeGam*5$YweP9?K^",
                    "type": "math_number"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": 165,
        "y": -625
      },
      {
        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
        "fields": {
          "NAME": "boardMethod:GetMainPlayerUnit",
          "THIS": true
        },
        "id": "o?wF%vk2ha.u*7Dmrfi+",
        "next": {
          "block": {
            "id": "?|6-YZD3;dbHn=(A_s9X",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Position X (필수)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y (필수)&quot;,&quot;name&quot;:&quot;PositionY&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "unitMethod:LookAt",
                    "THIS": true
                  },
                  "id": "QWHX4Fn~DdP`!*yRUQbL",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "fields": {
                          "NUM": 0
                        },
                        "id": "_^jmI+?/jtIcsL7gK#,y",
                        "type": "math_number"
                      }
                    }
                  },
                  "next": {
                    "block": {
                      "fields": {
                        "TYPE": "caller",
                        "VAR": {
                          "id": "}rmh$SU(#@=uzbdUB|Yw"
                        }
                      },
                      "id": "o+,4JHCZ:K2sgw1seHeL",
                      "inputs": {
                        "VALUE": {
                          "block": {
                            "fields": {
                              "THIS": false,
                              "VAR": "unitVariable:FreeRollCount"
                            },
                            "id": "!pMeT#7.uAU/-{loj^-+",
                            "type": "variables_get_reserved"
                          }
                        }
                      },
                      "next": {
                        "block": {
                          "fields": {
                            "TYPE": "caller",
                            "VAR": {
                              "id": "lsHI9|EJBj(B/Q0O#yrV"
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
                  "type": "function_call"
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
                            "id": "lsHI9|EJBj(B/Q0O#yrV"
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
            "type": "controls_if"
          }
        },
        "type": "function_call",
        "x": 175,
        "y": -965
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Unit_DisplayStand_Update",
    "period": "15",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": "Ka74}h_Z%I`:bq]sG5Du",
      "name": "Gem"
    },
    {
      "id": "ZGde]]ZJ4zVk*m0hOpe3",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "lsHI9|EJBj(B/Q0O#yrV",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "iT](cqrdt(hR@Tz]!de@",
      "name": "Unit/Time01"
    },
    {
      "id": "6LXS!|BnH88:/OLDxp3X",
      "name": "Unit/Time02"
    },
    {
      "id": "@bDfoM.Cn(_kJDt3w1f]",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "FeIH489OR)JtsVk~1ki/",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "LC`D0EGM?knGd8]r+rUL",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "%nz.TY[$1]bWCFU|/A.I",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "v!:k=6xuPbQy)i{zyt],",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "VR:T:By,4w;4%s}b^E5A",
      "name": "Unit/Tick"
    },
    {
      "id": "X}]Zil=k7AhivW}H2_5#",
      "name": "Unit/Rome"
    },
    {
      "id": "cdR:LKi~KYS*f$i#FGf_",
      "name": "@Unit/Delay"
    },
    {
      "id": "DE;;?iZtZo?8*:di}!fB",
      "name": "@Unit/Range01"
    },
    {
      "id": "sCxJyx)#h/|E[S7eZ$x2",
      "name": "@Unit/Range02"
    },
    {
      "id": "aMaOlKMh@efbwvg[oE1f",
      "name": "@Unit/Range03"
    },
    {
      "id": "M[=#a*|~PQmx6wjyc`8g",
      "name": "@Unit/Range04"
    },
    {
      "id": "*^K9w6-,*TBwb0CI)L-j",
      "name": "@Unit/Range05"
    },
    {
      "id": "OxsE[:S~BjZj!-]{7ERV",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "}rmh$SU(#@=uzbdUB|Yw",
      "name": "@Unit/Variable01"
    },
    {
      "id": "N;.j^(n6Xq@TV+aMRb1:",
      "name": "@Unit/Variable02"
    },
    {
      "id": "5bG~Pm59i(3@k`^+ffU[",
      "name": "@Unit/Variable03"
    },
    {
      "id": "pih|mk{bd#_/2wo[6{=M",
      "name": "@Unit/Variable04"
    },
    {
      "id": "jBAIAj[#S++f(K{Qr!kp",
      "name": "@Unit/Variable05"
    },
    {
      "id": "v97wNEAKQB+CEhD%{V.J",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "AriHak)B13ENp?_v77}3",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "3gw,-@t*3W_7xbYSlGv^",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "yG3fll$R0f0Ke`C1FHRK",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "b`Fcw}XJ3G6h[gG2jp~I",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "nloS07uw+k7DHO=RO6_9",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "K{WS99r2/gEnE}hPuT~y",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "]kaETWMT[Z4P?nnhbj#Y",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "@hG2T|.2tu{BQOE:mL1%",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "!G+XUvx#^khD]e[XsWOd",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "J;UV~F)ZIdVptME-aMAB",
      "name": "@Map/Variable01"
    },
    {
      "id": "{m:9-qn_e+q:e?$c}Ktf",
      "name": "@Map/Variable02"
    },
    {
      "id": "xXC_$l^w~EIV_J#mc2}A",
      "name": "@Map/Variable03"
    },
    {
      "id": "*_9z/R:m,F`Or-D6aC.T",
      "name": "@Map/Variable04"
    },
    {
      "id": "Hi~d/4I.r[QWAAI1jfX6",
      "name": "@Map/Variable05"
    },
    {
      "id": "KnXFyblAlDsyTe#E*DaC",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "GwWcFB_E:dfG{FA|l4N6",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "K3I5Py4}|Enn7U]D@Jk~",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "n9reB8^k6dre:}B`j.h_",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "bkFbG?!{.=WKY%dm4-#H",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "cJRc]RI@?aLVQl${8eg}",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "[lx}Z4q(rFd$o*kOpj7i",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "SE(hOTu!HZ4Pj$zjmn_O",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "BW-%dIH%+x9dNbzdG7-t",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "kRIMnaIY+Q($W5UkMmBq",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "Th@?@io]lG:T,y}s2*~N",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "dfo8t585M8{BF~RixU,b",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "P)p)Mmsie.Gp{FI9xM!)",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "_}q7)8a,TKWU5=h)[P@y",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "n}9X/aI:+(Md$z,O.*s$",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": ":Ag(gsxb1{V3V2m#BrS!",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "V:/9))2!%[R6Dlv@u)ar",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "rKdGG!LUs}V{,Zks$/Kj",
      "name": "Map/Wave"
    },
    {
      "id": "!il86}}z{PQAlA#1uEU3",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "H19`~Ae;jpKYzd+^ymoq",
      "name": "Map/IsClear"
    },
    {
      "id": "Vj5~9xfu_|X6uUIxc4*2",
      "name": "Map/Wave/Step"
    },
    {
      "id": "cu]~6SuZl*wnC=!P?*.*",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "LVf;,+G@Pic_83J:^4Op",
      "name": "Map/IsSpawn"
    },
    {
      "id": "$%#rYkcBq!S/OFTFx/Qz",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "#q_kaJ`z?82r[MqQ^HPI",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "_NT_5.K*i#Jp/O`!7^iK",
      "name": "Map/Wave/State"
    },
    {
      "id": "3Hu:m?*x+d(iGMc{`.Cj",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "hBAGbG`BeYFI!sEM6?02",
      "name": "@Buff/Variable/02"
    },
    {
      "id": ";Y@ONXjb;%bJV|OB6?D.",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "o%[CX7kDqT`wv/jttN*e",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "n}oE^n-QP~3hC0[[w)Qy",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "a$/H$MO!W=HCfx1,{8JR",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "J24K6F^8y{)7z?yexO})",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "GBB:r)+)Kr%Dq(w:Z}.J",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "1caKiO*:I-h?|t2%du_1",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "|VwfU#+)CpJ}m#u8Nx{q",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "2E`av2cO*]K*tt33%r_0",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "-g}Mi;I~),7w.7hzc!AD",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "+!i)-?|DNKw~br/J=]R]",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "lrLqd+W^jZ!5=xW{x+;t",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "HzHOS=FBHP?svDqjt;Yy",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "Ps-mGkFzum;1%8U7y8Tv",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "OaOqk[?vE19Q@{1PaOCb",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "%.I$_PghwU$L!esn8sL!",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "Q4u/{ajGKlZiG)6#3mo1",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "dckCOl#KF4n+#e0sB=qa",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "?`K6tyK0o*-(/|nNrw/F",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "!4gDxoX*},qUETOn?F@3",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "IYoGj|)Q`H$Zjyw%Vslw",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "Mf0=*Vh7}G_{AX:1`*)S",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "(d69`RW6:np_6,d8gnSY",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "lY]KC9aUR*^|0:*XQ6%H",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "Raz*nk,@Z9/7GZ|X00H9",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "-+Y+9Th:)}:#E7]Vw=i4",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "0~a4(Y]xH!(9($udFymP",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "qj%MUo=Rx*faMe^,7Z.{",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "i9T-qdQ*+CBU(^fuzsV_",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "Z0L*YKv*yhdKELN^e]fN",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "b~`?.h^{)K_%S~f3T*TJ",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "-DHf/3,aP$]_qKTU@,3(",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "+AlL3.EmJ^;LQY}iXwB@",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "}Ru0S0wm!Q53VwumNL|Q",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "[g6%.advHY9Qiqf/h9~W",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "]}!Gp.aT0zrI=#zN,#5i",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "(F/8Y=k*h3mN1D(h}$NU",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "0b1;^WP=)ME[OsJ*qil;",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "b^)U_/}kbMWnC-|_?:|,",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": ",%,)+%tk1z5vIO/4,K9Q",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "W^o5#|0eq2K-1Nv+(zpn",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "k}8v2C=xVrYhNFvpOBv?",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "4xsZ{OTzr;~gVO}[eVW6",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "MjFn2`L08]^,XUtw-s7L",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "[H9:4,iW}nlQ-vVpS82Z",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "nW`0P0Dodj];{ol%L=9e",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "e`n{JbB/N^{c]FO)|]Mi",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "t=Zj,p^~n).?ptf#-zZF",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "FrzlCk_HLqO*?!!s%,dZ",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "pc.$%h7m_%OHn0}]e[AH",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": ",iLNB!s|X~xS-OOpoGV-",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "k@fH~vXAr,Wa7~omkOqB",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "j7fG|ISEq6T{=Muc:n=a",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": ";{leB5C^:%!D`.1$O,kG",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "p=-?8:14IpjP0s9j34nD",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "L-!8qJJqbBVks#@b8q5v",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "]?idn[/UBkYcdf?t33zp",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "KCr}UO{wP4vHaVW]ZYQ%",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "m4{5dlE)BxFZMZ8o._oM",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "fX0jNn%hyrR2]d4:0eGG",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "%w2|?-po.MZ}Oa2*bYS(",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "M$jTS6r!K{+l(WOY[+xO",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "JwbpJEJr%S*O692,[*bF",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "]Kvs8Jvs;B}`}g1U81Ow",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "hrc#waJv^47hs]C[J4S$",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "{Jo`9Zk6M(,]EC;|X;n,",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "g:VO5?su=x{s!qn[EiB_",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "o^KX2f-b5wt)KU.xA~j#",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "{W[s`f3xbXsuI8x]j/TV",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "v$OD~]P,2fZE:[m(}Yb*",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "059K7Jm6eD8yvHxZ++^9",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "fb8iOvTk*5gOw(Pjg*PR",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "2Vy0N6[khe`W]]UD2M0M",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": ".7fh2S-FhE!-E%!5_:#C",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "iN9G(^mpoB~FZ.,;h,8J",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "8Zt%x!yaX.9(r*Qw~u}I",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "v~N0ij$W/C/EyeVR*5%,",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "o,)-:,+sIu=,y[Bd5{OA",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}