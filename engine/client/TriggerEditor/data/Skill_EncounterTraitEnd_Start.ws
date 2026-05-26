{
  "blocks": {
    "blocks": [
      {
        "fields": {
          "NAME": "Log"
        },
        "id": "(2p8#n75R%P[,0?7(loM",
        "inputs": {
          "TEXT": {
            "block": {
              "fields": {
                "TEXT": "Wave End"
              },
              "id": "ESy.B4JV;NtDsyDp.Ed3",
              "type": "text"
            }
          },
          "VAR": {
            "block": {
              "extraState": "<mutation></mutation>",
              "fields": {
                "TYPE": "board",
                "VAR": {
                  "id": "qSZn}HVty2Ogr%f6[J)h"
                }
              },
              "id": "m:VsJU[~J4Dw`dL*vz2*",
              "type": "variables_get"
            }
          }
        },
        "next": {
          "block": {
            "id": "+,!`QlJ9gvkwpeM]]=1M",
            "inputs": {
              "DO0": {
                "block": {
                  "fields": {
                    "TYPE": "board",
                    "VAR": {
                      "id": "qSZn}HVty2Ogr%f6[J)h"
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
                                  "id": "qSZn}HVty2Ogr%f6[J)h"
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
                          "id": "_Q[m^_`abS;#sm;yvV!2"
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
                              "id": "z_V8ol1/:1`{}mzBQnyT"
                            }
                          },
                          "id": "rlSwaKcSeq(DA{{MZ(=]",
                          "inputs": {
                            "VALUE": {
                              "block": {
                                "fields": {
                                  "NUM": 0
                                },
                                "id": "?HQR-of:xq$`%deGt-#r",
                                "type": "math_number"
                              }
                            }
                          },
                          "next": {
                            "block": {
                              "fields": {
                                "TYPE": "board",
                                "VAR": {
                                  "id": ".FO/zmC2L#IX6`V)UZwF"
                                }
                              },
                              "id": "Q(aXp9#qlUsc+nD)R=J;",
                              "inputs": {
                                "VALUE": {
                                  "block": {
                                    "fields": {
                                      "NUM": 1
                                    },
                                    "id": "kfjrr{`8@$/X9@[[LYzW",
                                    "type": "math_number"
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
                  "type": "variables_set"
                }
              }
            },
            "type": "controls_if"
          }
        },
        "type": "debug",
        "x": -795,
        "y": -2075
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_EncounterTraitEnd_Start",
    "period": "15",
    "triggerType": "0"
  },
  "scroll": {},
  "variables": [
    {
      "id": "UC?:_RX37/2L|X!J}mbE",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "=zE5L$g0S.7}I(`Zs+Xi",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "ejQ-c^+?}z+u4)DdS$9$",
      "name": "Unit/Time01"
    },
    {
      "id": "b9_pi,]9:/x%j%l{GXl6",
      "name": "Unit/Time02"
    },
    {
      "id": "Qn*KS{h34I**7@qvdKyc",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "i8HQa{k^CMP1sny8#28L",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "OsXOuVaTPb-2?c=.eVch",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "@YykaK;VBQ^ZHzEGI!Y^",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "iPe2rch%(`Y4Tq;6.KcH",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "K9?Eg@G]]d$1^Q^M,IHw",
      "name": "Unit/Tick"
    },
    {
      "id": "or){3tyYx[|L1s]Q$l,T",
      "name": "Unit/Rome"
    },
    {
      "id": "-Wj[5+9cH@4^p4xxW+?O",
      "name": "@Unit/Delay"
    },
    {
      "id": "1n2G$E0htH_d;`3bQ08Q",
      "name": "@Unit/Range01"
    },
    {
      "id": "]0o$k2~~*Dd;_@3x}Br)",
      "name": "@Unit/Range02"
    },
    {
      "id": "J5{:E[^q`%/f;KxFR1k}",
      "name": "@Unit/Range03"
    },
    {
      "id": "|k6Upn/=?BRMOU?d,/^O",
      "name": "@Unit/Range04"
    },
    {
      "id": "!*R_c#)c)$:#z5zJCLaq",
      "name": "@Unit/Range05"
    },
    {
      "id": "ZgtxrC;m%I;]~MWIhC9w",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "gw*.6q1y:fpd3[.`Rk33",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "%5lu6?kc@XQ*/kO43[{m",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "L684N19FBTJ(caVCdwh-",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "tO63Z]#dag$|:Fuo{99K",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "7GN[.g9AzxMcwN{JY_QY",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "rxgo7n$w2]UP3Y=v{Y)b",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "$@=6?D*g-SvDg0P79,@[",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "aszbx3alD@FDuB^4LaGT",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "j^$9{7*4Yv?YMA%eFw/9",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "eqNk!q3+d[JV]X_5,Hn5",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "yMj4K]%V0y3y//_P8GJn",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "zM5)IKEkW%Q/sgK~JRWD",
      "name": "@Map/Variable01"
    },
    {
      "id": "O]Bt?U)5JapN_0c9Hee^",
      "name": "@Map/Variable02"
    },
    {
      "id": "mwf8yO+57jW@5.*aT5)Y",
      "name": "@Map/Variable03"
    },
    {
      "id": ".FO/zmC2L#IX6`V)UZwF",
      "name": "@Map/Variable04"
    },
    {
      "id": "!?$YhI$*;Fym~mjI49/-",
      "name": "@Map/Variable05"
    },
    {
      "id": "vmMs0L|tx=O~UuJA-)DV",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "|%mnILi@#~W?K9S.J!a2",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "{ia^VY?}1$VMxD{RgKqm",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "FIPW6^oUCY^;Lw(cUaVB",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "UK]Ngv`i_!-oeEp1.|Y)",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "#XyBdWr_,cCc9hPM3gYh",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "R(g]E}r`J0N48%1:quJ#",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "UMZg7RzQ6^p+`Nx(!zQW",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "NNR-4ZuT}agDF#WX5}?4",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": "/Pg83:xC2Dq+ZOsrVQ8r",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": "Zv-0H|V={9d)^Z?eo9*B",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "gHgv0gKdj(v71M,2dng_",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "f.zrsud8XN[y`wQ]lG!f",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "xz%PKRqpLsCvQGI4}mQF",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "fpG3b:R8m8$]JlY(uy~_",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "hx#Po/O$-[e6FblqB`KT",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": ":{VuKW.loE4~JK,u4L(X",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": ".~f-*minVGw_pZoC+0kb",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "`=}jiThg).5H];8rZ|kk",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "9euIpxUEgLPKq?etd;9C",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "c7vuc1Uf!3;vu6%mQC}5",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "qSZn}HVty2Ogr%f6[J)h",
      "name": "Map/BattleValue"
    },
    {
      "id": "e?c$nBQZ[%df}!8A.xa5",
      "name": "Map/IsClear"
    },
    {
      "id": "_Q[m^_`abS;#sm;yvV!2",
      "name": "Map/WaveCount"
    },
    {
      "id": "hpDCdQv)Q3z3A|rN],$R",
      "name": "Map/WaveTick"
    },
    {
      "id": "z_V8ol1/:1`{}mzBQnyT",
      "name": "Map/IsSpawn"
    },
    {
      "id": "X=i?ID{Ks~Xp9Ob9st*Z",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "{o/qsktp}SrelTvevsuH",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "ECFbbr1OmPI!Azc~*jhx",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "e?p[H503M9O|eG2)$+cz",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "[Sr%FXny(aJ9Jlm}pr%;",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "Cx^eRhz}K,-AX_LleD8l",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "FN$JzS:i@OEM6C}0T%%,",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "Ly(=:I26jds|H3NVBNO5",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "2yCGEeO[K=JR%AP!d{lX",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "xuwbhtX#mYHua+@i%=[Q",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "[NAvP1`)gUT0/JL60+qi",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "/`Si1DGM4[GUASxkTg%h",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "UzEm773!7ok]`o}Iz]?$",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "5iFD8P,^w[g*G.^a{_do",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "v.a2-fToJ[Yb4USHb1-J",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "=?yFs0x!R4U%G4_U9?f9",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "1jWxv(RpDPeJKjM[@)[=",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "Yo$V0aU!IosVEHHFSRG4",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "`NXT},zX6HqnH)3#II(h",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "B0)iyJgU6o(tF2`{Err#",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "4(~n;[T+S[+HS1W%Nz/u",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "eWlk~QJ/g;ZtLE1Lkc7-",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "397XU+|twZ1{p-mP6Tsf",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "MU]p~putK+N^K5bv:YE{",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "8PT^dO582EVsy6t}54JD",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "VP~R-.tq4S.Y,eaN?HJ}",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "4///!DcZ4IoI97pGDLNp",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "9~I5rsnWgbb6+yT3IT0!",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "Ah}|KEk#;iIJ8-joPP|Q",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "4B5L9;KDry([*sV5yi-?",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "J#a27$B4$F$x,oXCHaoX",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "opbzVl#z/[NR7]gG39r!",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "Kl+[|O7wwz|{;if8u1-@",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "b|9O?$K$UzG8Nyado}t4",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "r_z-B1?HtFdBx$#s^}=!",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "WDM%-2c/Z%eK/+F[jtHt",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "H?REZ)=N:P~I(Du^:Z@]",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "4*%+WMze4-e]A;Y1_KI`",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": ",`b8)okZT*G8~/kgU;ZX",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "4k43-+vwt}l/6,D0Hch`",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "/Y^*ygK,*5~M)Ff}w@-F",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "KEiI;!H;MTPb3gcRLl;e",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "AvG,,-H=91(,G8vQf}O.",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "G*kbd/2?})u8$G6Z$Df(",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "w@AQ%4r7vZj!kf8G4K/y",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "e9j]t*Fe!7^gR9qFptak",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "L)q[kw6DD-Zv|Ebv(r_+",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "qDV[M3ncbuHVQo$RcI6J",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "0!zw}fekJvhxx{5PasV@",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "5V#mt^Fo?~~cFLLIQKvc",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "429KJBUVnHm.)ap,zHF!",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": ":e*.6UnPu9G-rz^rGtkh",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "dh)LESM$F+9vs7S*!?b}",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "POM:#8)9RsH+jZNzf@rV",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "bI_0f.WN/2FG^F7LPN[^",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "_8=~$,,(L@V*WRMX${8i",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": ";R/{r9|Cw2Sr%PBun9Fc",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "!^a8@Nr@h!}I+@1?hta`",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "[4mxBn!hL+y|AFO1cO3p",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "6#qB!Z`3JlO_3Mju]q$I",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "bo)/mPlYg]CNYz;?Mt7*",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "|!bL^:#cs`,`b8D*KgaV",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "#]yIE{y5P05KbvUC[.CL",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "o+[UIPam5z5E/]T8`xe`",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "PfWJEkjiUG7dy/F#CVED",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "VnXp+GM}v__79de`qIB.",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "d!5O[s931_2*`E9`@6@?",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "Mmc*JLowi2b+^Pn-]-,w",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "bY{9$[Q9qyhgl!nPP|[W",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "`mI|?}kSc@8zI.PtAF7C",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "e52qNn?vJAd^aZ/+#;58",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "6*yZT:b4gHg+q=Ez#DFT",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "I9(nFjwyIrCp?Q.S0)k%",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "=#it=0mA:GgQU|.VlgKU",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "P{wA1#WRo8)JrZ3j)UW,",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "?#taZl)12r4LfuPYOF76",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "E~ImmoS+P3,YaSK+M4iS",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "orW$,;DUOAqTAdFFF|{p",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "%V#t^8yl,hn{#aEYMn$.",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "YDzbREj/M[WQO3q223IP",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "*V^|CT^7!]+Jnjg^wpR;",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "hnxr*=4Z6ml/zHsk:dxn",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": ",=b.:K:~93b~!fs^Li_,",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "}5eS-xp(GyH`YG?Qc95l",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "E8)6rLkFVpuM9$`@R+s|",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "k.GF25|(r1QGY|u7)R1?",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "sb_I$Ewb0N#;[!$|{Mtw",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "D+A2XZBa%xul`iA@a6Bz",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "Uy5^U_P)):^evrSR6lmn",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "A+uFap5e@|N6vl$-bp_@",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": ",`wFB]X{(]$4:xCAOho*",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "o93=ka/CPH1KEjj11fjy",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "n}k9s3(xwiFz9@,{-%UF",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "l`b0atu:L8-ub4|o7qs3",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "zl;y.V~V-S*9d|H6auh)",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "($,ihmG^r/)j^S(*n4B[",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "Zo!udn2g4VBV++*}UmTv",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "EG*!8QE+;p_CBfre@!]A",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "$s**wI}H-;h=*Z+I%Ss2",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "_5kj]A#A)d2}D;+lLRh$",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "/RsaYbWN`~_8p/sm0avQ",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "7S;j$NT1(]R,L}G1.w%c",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "o(3Rc7g#^;=a!C-=8XiP",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "FVh937An-PVyh~WgC~1h",
      "name": "@Unit/Variable01"
    },
    {
      "id": "81:B+gMK@g%N$5^CV?Qs",
      "name": "@Unit/Variable02"
    },
    {
      "id": "Az%]8t*O,2WXXJt9{o5S",
      "name": "@Unit/Variable03"
    },
    {
      "id": "Wam93HU!pJcc3!K_T%1^",
      "name": "@Unit/Variable04"
    },
    {
      "id": "X/SeSei,2sbWrp|R_G(]",
      "name": "@Unit/Variable05"
    },
    {
      "id": "Xm}At6yAcC]pP5lX?Myz",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "_8q]p.jq_y+Lp:%3lA|c",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "^U*s6Xe5CKgLdggctKNb",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "M~9W.0kqF=%97QvZkv5l",
      "name": "@Skill/Trait/BlastIncreaseKBPercent"
    },
    {
      "id": "]k#Za^o-:r?As(0N=.AK",
      "name": "보석 상점"
    },
    {
      "id": "H{+wH}c@z3jt(QSbKb.:",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "jIsB3v$dbfI!}J$b_NXa",
      "name": "Map/Wave"
    },
    {
      "id": "fi^|D/bC{Z.FpIY::$^(",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "_K~)8dT*:)S8[Ix{GVkr",
      "name": "Map/Wave/Step"
    },
    {
      "id": "0_9$0$xz^H;X_V4VT?[r",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "@EsVB/u1(CS^)O(YC__c",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "UX=$]e!?[IO_l$@:/+NP",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "RpLz=6bg)q~*/wW%FK$2",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "o%VpsOg#GQ1xO--@g85g",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "y:*JZ|E(R*y(]u?PKi[O",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "?*s]+^;Bub+%vHcRnj{(",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "Xf/CsGj-k.HiTqqYOhY%",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "w=@L33tJDR]*mY7@uB2*",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "v:]9*HC03IYxsy3aWzoB",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "Wl9lP35#g;ktNNkErO4T",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "bANweKi_EdjrXX#oLB2X",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "AQYqc_B*^b`16KhgGp6E",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "zfkrO*`qAi|sj7lH=3(T",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "U@Ax37gDHk*%vYF:vE/M",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "NiFb)EMO9QDJfRj9miwz",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "C#m6^*2XAKZfMq5Lr9ME",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "JcGN],0I#8X2qV5iU#NQ",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "k!#O)f5BdA@V0xx/2,e@",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "!EfcR(OGRIh!,%(eD7,V",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "[y!NXcb~q+l=I|Ms%DTk",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "otMURKq{Olf-f42cQFyL",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "tD(y/utIn8A,d5G4yB,b",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "$36Ix!EH]r7CbLeZ1npG",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "h/sMO^}7,9sWTk#N7?N%",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "Di.)DZ!}Xhp,soxxXGmC",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "OQQOoz^8f`j$8*9.lz0{",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "GKNCW-lRl)KsMn1GYwis",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "@}?YfF$Ih@_Dfk?QF5cq",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "4_^CwC^wX,[$7hd`}#B2",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "3#X1Q|VM+Z;LwlN677tM",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "RI-2@3#j_+]-%VojX`8O",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "iXNDaC@KoJ.Jp+}q=*S%",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": ")%,;G*AG{fTmE2kXvC@H",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "xd4$]i-L-e7![({*~kLR",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "Wm/no%(BuQ)QJo=[B2(!",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "*@GyUr*~%HGkfK2;QLTI",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "|^vMWd#gvYeIxR*f}4a4",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "-xQL`Gu5Yzk+[C+p0}V/",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "{^j6waTunY{M$^zt=BKC",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "JI)LM5x#qaIW^2p|X9IZ",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "s)!g?F5}u9=Q{vpY7i/k",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "Vyj-Zuy!*lYNFgAS[pcB",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": ".Fa/exQBx[dhzeMtIbYO",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "${)4F=K.tghESbQNjez`",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "6R4#@IvbpALL|-%k_Q,q",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "+_r1!HdX%1#w,.y`BV|=",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "m9L_GraDYz`CkuY2O_oN",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "Z1+D_?~nb/Iy`hi5OUtA",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "1pF*4~;wEQ9oklN5$90J",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "qSxAG$1-^aYOxqG#ppwd",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "Z+e(^N2]Y_hp2BSbmH?U",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": ":^CnoxvOz!^2E`ugsk,6",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "=}NjcB]abt;ZdFmb]G!n",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "=!%*0e5vTbBWea-?C)d+",
      "name": "Map/Wave/State"
    },
    {
      "id": ":p6;9#cj$.$IM*/;SH=I",
      "name": "Gem shops"
    },
    {
      "id": "PNF%OOT1Z_3Uy22@h0q[",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "^UY$OQL-BQK!u{:1)K0b",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": ");gNM59yii63JL6D[@U}",
      "name": "Gem"
    },
    {
      "id": "~D6**;d[z|:Et]#F2@lc",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "(PN-N!%V+XF?F;`,%18a",
      "name": "Map/Player/Moving"
    },
    {
      "id": "?E^1W%{D97;{BEdX3m0,",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "XFP#^U384dJOwlj_F$K#",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "b8n.u1p(GCZ!H{.!4pDZ",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "-h@=Qb^3r8unBLv9lHAT",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "bT:36%R!]cSeQC,*YMEA",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "BHdo~)3Tx!hc(lzLjTD9",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "nsSfO(EirR7G,UJNycn@",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "+Ju==EvGcdr9$G)z2NTV",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "Yj_`^a0n6fnOOZsxYyH,",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "/{bMBr{qph0](4YJ.3zo",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "Wv!KcapT,IDEnw/ts+u@",
      "name": "@Map/Progress"
    },
    {
      "id": "^RB38vWK^a~2F(0A0:(`",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "0rCsC0=T/*gO;43{Aa@y",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "PbW;SjIZDxU17Y!ZY|}6",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "Pq7%v|Ju?SQl*qIM*qqx",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "X4nXZxQr0.ISDE`1#Sv7",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "L}$iZZA/H@Xa_#0K~G|p",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "3YK)}?V5-r0J;+nU:[kJ",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "o7a(@^IDxc1]D$84}BqG",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "73SD:ZbArr-~i*`r+]bA",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "fB2BVG`IJl=zc#0NG1=Z",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "U2YUlVbEB0FAz;C|1Rw1",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "#32qkj@X$(@k9GM?tA.T",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "LNV3YrZYxx-l7^7[o=XS",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "U#]=XlYiXDHaA*7EgH|7",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "2+F7=_[ZzbDLH#{suc:.",
      "name": "@Skill/Variable/04"
    },
    {
      "id": ".bo80{:ZbjkLZFaW!M,5",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "}!}UakW1|5ttG6d{aaY6",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "+f4d,(~ZM2ydCFP@H)l,",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "9HK;m?rofR!^fu~kSC+k",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "@XouaN5L/@%?9vY;@_W{",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "^df.EFh#/_2|LZwHZj8K",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "0VgpD,m$:qiIFFm(qNaR",
      "name": "Map/DisplayWinningTeam"
    }
  ]
}