{
  "blocks": {
    "blocks": [
      {
        "id": "(16Fjj)+rko*:NOZY3pC",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"4\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration&quot;,&quot;name&quot;:&quot;Duration&quot;},{&quot;comment&quot;:&quot;Sender(1: attacker, 기본: 현 유닛)&quot;,&quot;name&quot;:&quot;Offset&quot;}]\"></mutation>",
              "fields": {
                "NAME": "buffMethod:AddBuffToSender",
                "THIS": true
              },
              "id": "kI*HIt0zQ~Sa]%g!tygZ",
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
                    "id": "zq?98T))()w^P?dbgZur",
                    "type": "variables_get"
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
              "id": "`!3I;/Zlp_@9[IGcRtBh",
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
                    "id": "s@poq(k-bBMYPrzTRP}(",
                    "type": "variables_get"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -465,
        "y": -715
      },
      {
        "fields": {
          "TEXT": "저주 적용 횟수 당 체력 +0.5% (최대 100%)"
        },
        "id": ";|4C6ysxD${galxh(B{s",
        "type": "text",
        "x": -455,
        "y": -795
      },
      {
        "id": "C*,X_4BFV6iC$boYu96E",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"4\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration&quot;,&quot;name&quot;:&quot;Duration&quot;},{&quot;comment&quot;:&quot;Sender(1: attacker, 기본: 현 유닛)&quot;,&quot;name&quot;:&quot;Offset&quot;}]\"></mutation>",
              "fields": {
                "NAME": "buffMethod:AddBuffToSender",
                "THIS": true
              },
              "id": "4Ba,_~tt*G$1TM4gCcE:",
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
                    "id": "RLVJ}B#Xq?W~:-)gL5*q",
                    "type": "variables_get"
                  }
                },
                "ARG3": {
                  "block": {
                    "fields": {
                      "NUM": 1
                    },
                    "id": "I3t_vsG|)J_B=!p.pfmA",
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
              "id": ".}4#TSV,fXPrNZ@q~OKQ",
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
                    "id": "|`NprIz3b)-oF}9{IU,=",
                    "type": "variables_get"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -455,
        "y": -375
      },
      {
        "fields": {
          "TEXT": "저주 적용 200회 시 버프"
        },
        "id": "1FlRRCFO5$^JZa96tunI",
        "type": "text",
        "x": -455,
        "y": -425
      },
      {
        "fields": {
          "TEXT": "말뚝(저주 딜주기)"
        },
        "id": "j(*f6|K6N}:ou#ZFr:7Q",
        "type": "text",
        "x": -465,
        "y": -95
      },
      {
        "id": "|7J[mX5TSz6bdCn~jm`D",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:AddBuff",
                "THIS": true
              },
              "id": "!h`lI1.4l$f3tOu`2,C!",
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
                    "id": "EtFC`7k2DC^^t[yBC,.d",
                    "type": "variables_get"
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
              "id": "u|=5U%W7P-][~=Q(F.3|",
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
                    "id": "6^$@pjp?eJ-pkk@[BkB_",
                    "type": "variables_get"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -465,
        "y": -35
      },
      {
        "fields": {
          "TEXT": "저주 강화(데미지감소 )"
        },
        "id": "#wb=r.GjoISkUCBH4LZ-",
        "type": "text",
        "x": -465,
        "y": 225
      },
      {
        "id": "qznK@`6(jl^[-R;-(`5T",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:AddBuff",
                "THIS": true
              },
              "id": "srW-m.u1X?-f7mm46Mf9",
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
                    "id": ":f|-Uu.pv@gm9|;*2SQq",
                    "type": "variables_get"
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
              "id": "x#p`gRh*sNvseazKx53Q",
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
                    "id": "t(/~}Jy;5k64{DzlLR#B",
                    "type": "variables_get"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -455,
        "y": 315
      },
      {
        "id": "Y9r(M%o$=R#;],{Yu.mw",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:AddBuff",
                "THIS": true
              },
              "id": "Nc.f{/IOqPx.08@hHwi0",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "km,t1[$]?Sf;/AHhzY`o"
                      }
                    },
                    "id": "ziK8ADv*LP+`4,v-7lq%",
                    "type": "variables_get"
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
              "id": "SNEG!*EZ94@7mi4+AE4@",
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
                    "id": "moDpalOPI1~V5Nv9tS^`",
                    "type": "variables_get"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -445,
        "y": 655
      },
      {
        "fields": {
          "TEXT": "저주 강화(받피증1) -3616021"
        },
        "id": "BI*NFN)WFD$2nzpxrI?Y",
        "type": "text",
        "x": -465,
        "y": 575
      },
      {
        "id": "(e[f|2L{W0{.@gO8d(cf",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:AddBuff",
                "THIS": true
              },
              "id": "L,aSps6hVt;m6WZdug?7",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "o%M7UQ+6Pns7N*~sUmo0"
                      }
                    },
                    "id": "Q1}W|}Z-_23?YA:tL7^%",
                    "type": "variables_get"
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
              "id": "]`ao.!;+kY{gMx4Ll@[8",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "`dAx:X2%JWICF_Px-j(S"
                      }
                    },
                    "id": "$SNw@q7Q^N=HhI-)zMwN",
                    "type": "variables_get"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -445,
        "y": 1015
      },
      {
        "fields": {
          "TEXT": "저주 강화(받피증2) - 3116021"
        },
        "id": "~!TL?G;z5^KF-u$%r!Yx",
        "type": "text",
        "x": -455,
        "y": 925
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Buff_CurseManager_Start",
    "period": "0",
    "triggerType": "0"
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
      "id": "j.gzWb+LCMnD:RtZ,Q!{",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "V1}9PdP#aO-Au?%2%IVj",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "#|ghE6Jl%{yG?Vp1j2ST",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "C9)8I$ee;~zfccXJ^+^u",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "1w/DMU4if[L:zx~UUD4{",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "S7JeZ|S?h(#yK8Wu28/w",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "7`a_8_%)CS6Yx%Foxba0",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "kq}Z5_6efCX?JQ}g5`wc",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "vfek:6=_L9C$`H2ao`U?",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "dt*AN#3dW!me7Kyj-Ig@",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "3Qkxk_a#6UQOnEcloJKT",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "*)#l82TtL|CVX3uPiGW2",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "u1%uB:e1FA:WC)XsqE7T",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "vh|Fu?[sZaLiTcZ%p:(^",
      "name": "@Map/Progress"
    },
    {
      "id": "O,//W,Idc=IV?_g0!DqM",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "bUb}X#%v7-jn_Ofo1BH;",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "nwAnYdI1~;E_a@({_FRA",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "p.bI$*qK{4rhVJfCE;Q~",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "vVRS?KUBAh%=HYd!x8*k",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "$R$M72d3:4=){$`!t`G0",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "!ya0-Khmkh+^OhY=^T/:",
      "name": "@Skill/Variable/10"
    }
  ]
}