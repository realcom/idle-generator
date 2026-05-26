{
  "blocks": {
    "blocks": [
      {
        "id": "e3YtlX}teo%d@-==s%aR",
        "inputs": {
          "DO0": {
            "block": {
              "id": "!`]`KDj[$MQeo*cm.2(e",
              "inputs": {
                "DO0": {
                  "block": {
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "*dOcCyp-l*@!6xb6-4r|"
                      }
                    },
                    "id": "cBC|N:bKFm(@E$R+0:D)",
                    "inputs": {
                      "VALUE": {
                        "block": {
                          "fields": {
                            "OP": "MULTIPLY"
                          },
                          "id": "@q,.b,v[,o0u{n%y:pQ@",
                          "inputs": {
                            "A": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "caller",
                                  "VAR": {
                                    "id": "*dOcCyp-l*@!6xb6-4r|"
                                  }
                                },
                                "id": "H$5DPf/7huR!0SIbrN.`",
                                "type": "variables_get"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "{kfL3BS(GOYG+y,fOL6B",
                                "type": "math_number"
                              }
                            },
                            "B": {
                              "shadow": {
                                "fields": {
                                  "NUM": 3.5
                                },
                                "id": "RY*G%hq|H][zJdGG3^u*",
                                "type": "math_number"
                              }
                            }
                          },
                          "type": "math_arithmetic"
                        }
                      }
                    },
                    "type": "variables_set"
                  }
                },
                "IF0": {
                  "block": {
                    "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;}]\"></mutation>",
                    "fields": {
                      "NAME": "unitMethod:IsBuffApplied",
                      "THIS": true
                    },
                    "id": "t5-f|UYYILgRm(CaBg}Z",
                    "inputs": {
                      "ARG0": {
                        "block": {
                          "fields": {
                            "NUM": 3316011
                          },
                          "id": "y|/iFXZrhQTdXFD0kGIY",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "function_call_return"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "TYPE": "caller",
                    "VAR": {
                      "id": "*dOcCyp-l*@!6xb6-4r|"
                    }
                  },
                  "id": "hFlxcSEx%:BUmEDf+;uj",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "OP": "MULTIPLY"
                        },
                        "id": "(.22-cHIe*mQyt8gKyyV",
                        "inputs": {
                          "A": {
                            "block": {
                              "extraState": "<mutation></mutation>",
                              "fields": {
                                "TYPE": "caller",
                                "VAR": {
                                  "id": "*dOcCyp-l*@!6xb6-4r|"
                                }
                              },
                              "id": "UtPg]fDiG{twuy=Dpr/^",
                              "type": "variables_get"
                            },
                            "shadow": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "{kfL3BS(GOYG+y,fOL6B",
                              "type": "math_number"
                            }
                          },
                          "B": {
                            "shadow": {
                              "fields": {
                                "NUM": 2
                              },
                              "id": "36-;nrvM+`c2|(5,6aF.",
                              "type": "math_number"
                            }
                          }
                        },
                        "type": "math_arithmetic"
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
                "THIS": false,
                "VAR": "unitVariable:IsBoss"
              },
              "id": "`Um(~E:tvS;HHFFvUbcy",
              "type": "variables_get_reserved"
            }
          }
        },
        "type": "controls_if",
        "x": -1635,
        "y": -1285
      },
      {
        "fields": {
          "NAME": ""
        },
        "id": "=kpa;TP=f=?T=K}8l`AK",
        "inputs": {
          "TEXT": {
            "block": {
              "fields": {
                "TEXT": "hero sword damage"
              },
              "id": "XF13/2,d-X?_gwLEnp2#",
              "type": "text"
            }
          },
          "VAR": {
            "block": {
              "extraState": "<mutation></mutation>",
              "fields": {
                "TYPE": "caller",
                "VAR": {
                  "id": "*dOcCyp-l*@!6xb6-4r|"
                }
              },
              "id": "PY53TxIP1=6)sS5s!/16",
              "type": "variables_get"
            }
          }
        },
        "next": {
          "block": {
            "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
            "fields": {
              "VAR": "Return"
            },
            "id": "lROJ1t_/Ed/iZd}#GLv5",
            "inputs": {
              "VALUE": {
                "block": {
                  "extraState": "<mutation></mutation>",
                  "fields": {
                    "TYPE": "caller",
                    "VAR": {
                      "id": "*dOcCyp-l*@!6xb6-4r|"
                    }
                  },
                  "id": "t9{L$yzq^RZdtnnu4@1X",
                  "type": "variables_get"
                }
              }
            },
            "type": "variables_predefined_set"
          }
        },
        "type": "debug",
        "x": -1535,
        "y": -925
      },
      {
        "fields": {
          "TYPE": "caller",
          "VAR": {
            "id": "*dOcCyp-l*@!6xb6-4r|"
          }
        },
        "id": "Z6bWPF}m)LoHRmn0@`uO",
        "inputs": {
          "VALUE": {
            "block": {
              "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
              "fields": {
                "VAR": "Damage"
              },
              "id": "L:TbeL04#!+zS:tYdKIg",
              "type": "variables_predefined_get"
            }
          }
        },
        "next": {
          "block": {
            "fields": {
              "NAME": ""
            },
            "id": "c$/;X[T*1;hjq}h=kG+;",
            "inputs": {
              "TEXT": {
                "block": {
                  "fields": {
                    "TEXT": "varaiable 10"
                  },
                  "id": "64cX:d/(}O-fp=[_qkd4",
                  "type": "text"
                }
              },
              "VAR": {
                "block": {
                  "extraState": "<mutation></mutation>",
                  "fields": {
                    "TYPE": "caller",
                    "VAR": {
                      "id": "*dOcCyp-l*@!6xb6-4r|"
                    }
                  },
                  "id": "ZzWIkI=1o{vg`(6v~#)y",
                  "type": "variables_get"
                }
              }
            },
            "next": {
              "block": {
                "fields": {
                  "NAME": ""
                },
                "id": "Ms@A~eNM$rSf#V_3id9$",
                "inputs": {
                  "TEXT": {
                    "block": {
                      "fields": {
                        "TEXT": "damage"
                      },
                      "id": "IYJY$Bb@j3Ew=n8?4fdQ",
                      "type": "text"
                    }
                  },
                  "VAR": {
                    "block": {
                      "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                      "fields": {
                        "VAR": "Damage"
                      },
                      "id": "Ah*}f@IryAH%cTAJA,5*",
                      "type": "variables_predefined_get"
                    }
                  }
                },
                "type": "debug"
              }
            },
            "type": "debug"
          }
        },
        "type": "variables_set",
        "x": -1625,
        "y": -1505
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_HeroSword_Attack",
    "period": "0",
    "triggerType": "2"
  },
  "scroll": {},
  "variables": [
    {
      "id": "Q8E}nm;%PH#O$:C/Nzg[",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "Pw2Hb^h)$:Pmh$rCN$Vg",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "yKy%CbN.UWZ!DA+rri(8",
      "name": "Unit/Time01"
    },
    {
      "id": "vq}.j9IM~(M|~TPoBu{r",
      "name": "Unit/Time02"
    },
    {
      "id": "|=i,)XY_$x|TQp^1m(){",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "dB~Y/OJuTT($^T-DY_4%",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "7b7P5244`UPhE#|#$WQ?",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "vsAOZ1B8EcTEAO/*tv_?",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "6Z!bx([M,2p3pXnTv7BS",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "v@S4ODJhB7TwZZ+_2i:H",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "69}d4M)I~IXv3$|iNt!(",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "7tmw^S3^SPGu})S3Ibc[",
      "name": "Unit/Tick"
    },
    {
      "id": "_80WW@mb@2Z+ocB?U@HA",
      "name": "Unit/Rome"
    },
    {
      "id": "V3E:+:Hc]x;%}:wibY9V",
      "name": "@Unit/Delay"
    },
    {
      "id": "/$0@oWQaT@zYAVH+i|{R",
      "name": "@Unit/Range01"
    },
    {
      "id": ".-k#VQEfI?wQ#%+cGkO.",
      "name": "@Unit/Range02"
    },
    {
      "id": "(W;6.$$HDHz)l0qjO_?;",
      "name": "@Unit/Range03"
    },
    {
      "id": "T)i-b^)(vJQ}FFvaplOs",
      "name": "@Unit/Range04"
    },
    {
      "id": "d8eew+EiO3OFDH]o[3qB",
      "name": "@Unit/Range05"
    },
    {
      "id": "LUGyR4~v8VwET=m*-.:m",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "IH_ky5)%fyV8*LAk4b*Y",
      "name": "@Unit/Variable01"
    },
    {
      "id": "S|1+U!jG(7n0AHyc;l|0",
      "name": "@Unit/Variable02"
    },
    {
      "id": "TXC7-apEVD~afnDR}YX@",
      "name": "@Unit/Variable03"
    },
    {
      "id": "m-NOEJrH@+G)K[-r-Be)",
      "name": "@Unit/Variable04"
    },
    {
      "id": "Vt_3[P$i,ynk1$(r*=Cp",
      "name": "@Unit/Variable05"
    },
    {
      "id": "/(bx8~4_bjw?*)E2c|Ou",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "7UX`:-4?ki}r$gJVoKX{",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "IT`gDl=7sdKdIgOO5/z$",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "f{%;UVA*1S]k06JFhcP|",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "O;u;M!U]hU^9lCiS?#z}",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "3-!9sH.NZ)`woi^WHFeI",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "Bi+8x^t)~B#B~tfeNp`p",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "^W$^rwGcu:UVf,XD-G@x",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "|1H_M9Or9,rDLk9.@pbm",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "63/[hHyBeP%HQ]m5Ch}#",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "mW=Pb#H}*{RDDy}X5=Va",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "CSz[o_wa#!+AU]j0YAV$",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "bo@BP.3ruSdD):UhS45#",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "[rhBq5}]ZtGJA*p`X-*q",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "lD-SsjZTYtv%~a}WU#rW",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "8b[w:L{9xL){JZ`7=^sR",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "T^+vO2M2vS@/bF#U]#`i",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "67K)^7yZ7T^r%.8x.[w9",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "*HfcnO2C}%aY%B{+V]@h",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "wU0p;43p]B*KuNCKO_8r",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "tDSLC(DZe]SnOm_)OQ%q",
      "name": "@Map/Variable01"
    },
    {
      "id": "Rm_s;`o)hG-s[fRs_LBJ",
      "name": "@Map/Variable02"
    },
    {
      "id": "/2im6xbyzYC,av0rtI9y",
      "name": "@Map/Variable03"
    },
    {
      "id": "Ohs{6L{86kC^qWiA)HqJ",
      "name": "@Map/Variable04"
    },
    {
      "id": "1G^?e7hh[Pq+iH;SwC~2",
      "name": "@Map/Variable05"
    },
    {
      "id": "GHf7S,jlc9*s6N_d#tB.",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "CB2T3jhm?.!#bl%/{VZ-",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "~$(veE(Q_]O/Y33Q5wOO",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "2JWe0f-SjMn)bI]ZoiHm",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "{:rK!8Wrq7,m2GW[$[VZ",
      "name": "@Map/Progress"
    },
    {
      "id": "[$!vqy7hl]$Y5StT,JcL",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "S!1Qo=#b~W*Qz~?olY+)",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "se1PHVre~e(I~QBDG2OW",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "S-c_TeWi|.0su,Z9EVJQ",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "a(}.nKpeN,vDesme8NvK",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "nyKkxc[Qiz^T$V|o}9,Y",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "~O7RqHS(DB*OVm(Pui`r",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "@e{qWtdIHAGBY}5C4rC;",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "m$|l08}S1ksPz.t~U}[;",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "CInO@))w7-JVx+=trwG|",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "_[A7Y~zcxN$B9DpcGJO^",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "66k7E@8.)~$J4AO@Z+n:",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "x}wE2]}BY5Hs9b^hs@ED",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "OW8xdlv8o_{QDV/]oH5G",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "YjR^w9i$8O-RFEN9oQBa",
      "name": "Map/Wave"
    },
    {
      "id": "xhw%ue(j?7lgHtj$6n;W",
      "name": "Map/Wave/StringId"
    },
    {
      "id": ".2l^aF8[G~:)4z.2icz]",
      "name": "Map/IsClear"
    },
    {
      "id": "M0VbeAYPLA{!T3mZE#_7",
      "name": "Map/Wave/Step"
    },
    {
      "id": "~I~F+6fNsE#ex3#wTTF=",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "qN68P=D1EA2VGwmL%O!i",
      "name": "Map/IsSpawn"
    },
    {
      "id": "(,.B[fnw9R3JD2^+{pUY",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "m:jVC(~rMyNT`a?VxPSB",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": ",8)~z]fcvKub?bH*rcQ1",
      "name": "Map/Wave/State"
    },
    {
      "id": ")a;/NA[t:vZy+Up,XQY9",
      "name": "Map/Player/Moving"
    },
    {
      "id": "9V8j#UVbd5Ol5H66Gd+b",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "V.Rax=#=7L,.-u*I^0YY",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "vYtal#^iBa.zO!`vxN^g",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "c@fLh[3UkXZkC`1;0r|:",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "dJQ6ae|yMPcXS_aFcF,R",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "G#vda2O5]-,_=K3u!Ta(",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "r3`b{26Y,8cye,P($7zJ",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "WMrHS|s|7WJX~c/Tr$hd",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "Vwcy]{AiYGc6.6!U07_7",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "7$cZ@WMcvccI,=r-843T",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "ATNye[n[Q)v*,Xqm+nS[",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "*#)MGt5D`!MNkx1qPIsa",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "F}tJsYE._Z9vf1fJcDNp",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "x[p:b^^cZhNWcsJd|X-W",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "$g821rfJm,`j@KKQ)fx.",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "~}H)Y{pZmNBTe+kr@$Za",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "wmM}d=)L1Ys|ei:K*a9r",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "15n#60RWYKvQh2{ym{^~",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "ef1OkDIb-wt9)}ouiE~v",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "xY:imB$=9Kj#clY/?HD4",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "So@dUhG6:[I4gul-`K.m",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "a6?^O~va0e+j`UJ:b#fS",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "?dm-`Gw~qB.{__0$]#Ek",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "|^kb_w7!K$[x1xH$I,#N",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "Zk|3t#h5B_w!xQLysV@j",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "`J:1dz8%rTlr!_7DY1#p",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "t3aQZ-,S^]QL|EYv%N-O",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "r_,7:4/S{Zwtl]Y2/Gl7",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "6w@*5!gaaI6aF2E)hnj5",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "#!gOlK*{8E8Dha?)+o;3",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "*dOcCyp-l*@!6xb6-4r|",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "39}Sq=gHM_@39mx4Cc^=",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "6r,qGp.4W_GcIa4|las:",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "A?=pUD9iF`IYWEHiL_5N",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "k@bI(9G@AKH%D/+50hw5",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "(G1Ag@Y1ACaE*N.:1S4Z",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "{hv~Gi,,wu3gPdmSe1nZ",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "8?`,kKuR7sOQ5V_YAb0=",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "-#ITxgnjm+ob;qW2~_f(",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "/NMj#[w.[vM70nlNWqrx",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "JL^Nov0M:|E?E4#0L$Y9",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "aD|Mm052;nYaLL@$B3=3",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "l}JDsR=Q0vs}B?b9WuT(",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "a8s/T1,Fu]Lib!#{Z]3Z",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "N/XE?!3XO4:cKxaQ;tbi",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "u-$6,-`xYU*@h|nq;#0S",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "xiZiiw?ceq#5MY|~leLa",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "P3Y31/HvfgY;DqRDB?Zq",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "9,7LBmljR.V:dKS2:GN?",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": ":$x.C^9C.9^U/dy?0~QQ",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "Z,)FV7v_LT!F6LBpr3L[",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "::yQY-bKzWNkd4VaudHP",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "J)OV8wm_gMkNsrL33=Bs",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "@[V!xj@v^jv(/4yFSm|p",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "Jz%O_I/Ew{b-h2i#Fe8]",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": ".%wDd0(o?@{EJGQJoj:M",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "_.Xe@z]5@FbodlEymaV*",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "yHnH;)k+]]CiXm8qM.~a",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "jJz=F[9}E$ZQL![Y%:lp",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "fs](QOLS-M=)a=)`|Z3G",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "RQ==Zb|ocy5m$RG;ZeY4",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "L]Vha3NYm:[zxlnh9a4-",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "v3($JiNkE8mb-LyiTfXl",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "pclHZkzSt}tXG-SeW3jG",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "BrmzS0/c!|8f8e%pye6T",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "bD:-OYOX+*(WM}oRJ8cI",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "qIq@/LLBT]7a;{@!69!r",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "vadp$M1QYkI!i6hg+R#W",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "![0{TjD]{qBM8jDT_S}/",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "q+!W+?5)uHIt%0%9!(WV",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "kGc:|ng%:jxH|+C^!6}P",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "tY82Bplkp4jwX)K^=dB^",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "o2/a/l`L^7r%D^ZzHa5n",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "wUcKN%3xURY*gk#:bC)F",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "GI8EwXfd~?0kHOH6|=GO",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "54M^/p:OudxunmQzdQun",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "|@T#{7;-HMz4!=Z]I7y_",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "}uchgE`751Jy|]~;5~!q",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "gE={Bq^T4em.zY@CIy3u",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "tj*sw)sVK4YhJ{W0z?TV",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "cV.RG=se8eOMLRg{i^^W",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "#8mm1?j89{J1KwFi;!oJ",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "N(]`d2Vd.CX*,uJ3f-}/",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "QNIIl5KX_Z^z!QKZhGJ*",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "qLxQZ1~n2Hob5H1$-Hhl",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "x/eNsYqljA+p9PMG#@,a",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "vM#|[nYDD`Dg=ML0fd1`",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "TE6v)#s@R7LQ`)r,[=+1",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "[W?AvU0fGsKIv#cdKQMk",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "~b5-@51*[+TmLqd8XwXm",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "y-XlkT{dz*lKwFL$~92@",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "u82wCMI:1LB3JS/Mzm7m",
      "name": "Map/DisplayWinningTeam"
    }
  ]
}