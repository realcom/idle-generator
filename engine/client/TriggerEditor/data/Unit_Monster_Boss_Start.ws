{
  "blocks": {
    "blocks": [
      {
        "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Position X (필수)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y (필수)&quot;,&quot;name&quot;:&quot;PositionY&quot;}]\"></mutation>",
        "fields": {
          "NAME": "unitMethod:LookAt",
          "THIS": true
        },
        "id": "{W_U2ZANZD2r~B$d8VY^",
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
        "type": "function_call",
        "x": 795,
        "y": 255
      },
      {
        "id": "TMnI%|CIf/n#s4~(r5,J",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:AddBuff",
                "THIS": true
              },
              "id": "Sb}N8|a!`LSHZe`qO},;",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "yCMIC}[EZ::X-]%j1J,="
                      }
                    },
                    "id": "g3n/Ds]IzEV-Hy@.[~ak",
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
                "OP": "GT"
              },
              "id": "VEkj`wH+Lq^h;PR%)sbM",
              "inputs": {
                "A": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "yCMIC}[EZ::X-]%j1J,="
                      }
                    },
                    "id": "ksNZ:4na*X,6}i0f=@Mt",
                    "type": "variables_get"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "?/u$+xj#9CO.lk4u7KpL",
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
            "id": "94F4UTa8Z|Uy={6ZoAU;",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "unitMethod:AddBuff",
                    "THIS": true
                  },
                  "id": "rH;dL[MC)`-x)D/;of:9",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "extraState": "<mutation></mutation>",
                        "fields": {
                          "TYPE": "board",
                          "VAR": {
                            "id": "b*P+^X8TSEsFIRt@=`Md"
                          }
                        },
                        "id": "wDRS6x/?!I0-vz,{}C_7",
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
                    "OP": "GT"
                  },
                  "id": "MdX,7-|$6q9bqn=OY_s!",
                  "inputs": {
                    "A": {
                      "block": {
                        "extraState": "<mutation></mutation>",
                        "fields": {
                          "TYPE": "board",
                          "VAR": {
                            "id": "b*P+^X8TSEsFIRt@=`Md"
                          }
                        },
                        "id": "9HC]4talz,P|(s.dEg.4",
                        "type": "variables_get"
                      }
                    },
                    "B": {
                      "block": {
                        "fields": {
                          "NUM": 0
                        },
                        "id": "H)Z}?G7Y3Zwu5z89yasI",
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
                "id": "R;VDzQ5_6o)c7n:DB$**",
                "inputs": {
                  "DO0": {
                    "block": {
                      "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                      "fields": {
                        "NAME": "unitMethod:AddBuff",
                        "THIS": true
                      },
                      "id": "Lw0li)nPM[wf@1mfXah)",
                      "inputs": {
                        "ARG0": {
                          "block": {
                            "extraState": "<mutation></mutation>",
                            "fields": {
                              "TYPE": "board",
                              "VAR": {
                                "id": "!~#awP(b0YRed}gt{mv*"
                              }
                            },
                            "id": "HPu.u:cZoe;b@ubNwg!O",
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
                        "OP": "GT"
                      },
                      "id": "sKg:)`HM6q1}Sfr+Pi3s",
                      "inputs": {
                        "A": {
                          "block": {
                            "extraState": "<mutation></mutation>",
                            "fields": {
                              "TYPE": "board",
                              "VAR": {
                                "id": "!~#awP(b0YRed}gt{mv*"
                              }
                            },
                            "id": "g:ls}Zc;pFOf0FanMbq}",
                            "type": "variables_get"
                          }
                        },
                        "B": {
                          "block": {
                            "fields": {
                              "NUM": 0
                            },
                            "id": "XrkL`a`LvbBDC50-8bPZ",
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
        "x": 805,
        "y": -355
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Unit_Monster_Boss_Start",
    "period": "15",
    "triggerType": "0"
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
      "id": "Wh^NZ@sK(b|{{919#NT@",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "c9SM8[31+S%:TstPCggy",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "{RH;UI=~ND/gQlN2j)ar",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "kD5A;t9@{`j^}{w5?lez",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "G`X^4MJs72MO@9N5UzA%",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "iZbfAL2QmkWEm/Y/G!O~",
      "name": "@Buff/Variable/03"
    },
    {
      "id": ")P_-$;`ldJb[3hoo]MqA",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "VwuD}M*lu7izaNA};FW@",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "WUI]y0E$vo?[UqYe1I71",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "DO|=5*arxT)RxB3-.bbm",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "t_c`[Zr:cDBQvcK~#F.n",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "6oqp;|o43gANcsF8J3wr",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "eY6S65ENxRvW*VV[]0.x",
      "name": "@Unit/Variable01"
    },
    {
      "id": "L-?$)c#t$eIaccXTw1|.",
      "name": "@Unit/Variable02"
    },
    {
      "id": "GeH_h[18Wr.77A+F$WRv",
      "name": "@Unit/Variable03"
    },
    {
      "id": "`}v3vKnShPE:R+2*fNP}",
      "name": "@Unit/Variable04"
    },
    {
      "id": "Vbz3gBx=*lxlKeXEVGZa",
      "name": "@Unit/Variable05"
    },
    {
      "id": "G6@Iv6xjbqIj[2R=kz[~",
      "name": "@Map/Variable01"
    },
    {
      "id": "wPnhLBNY[66uYkruDE,*",
      "name": "@Map/Variable02"
    },
    {
      "id": "v3|ZEyWUmPJB$W~1$p#u",
      "name": "@Map/Variable03"
    },
    {
      "id": "lhHy#!P2[c/B#o3Y-X7G",
      "name": "@Map/Variable04"
    },
    {
      "id": "F^K?uTyrl5s1%`^{%fxO",
      "name": "@Map/Variable05"
    },
    {
      "id": "$o}2sBD0{P~aeG~+LdHq",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "ZT_s6LVOM@FjgTc$aplP",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "R%~L4Ajb#Q$mDFF/xl;`",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "uZMprareJHNwq=:US3?!",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "Aao/0Wz|;RWbwa$VD:hF",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "vv8QcUqi/W9(UiNIt^(*",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "?St=iGJXG[aH57HGMV^s",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "1QhFUX`gk1}AL~=`cY0O",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "Eh?encOkwVY:-%Ntrg;R",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "g2u#AHdXPg|Rdq/Q+VNN",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": ",p%.%Zl#fs%GAP]6ap*r",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "GzT2Kk7WSUnc+sHm6U*i",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": ",/7c,|ZobE%91@fFNt0^",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "E=I}SjnmOMTmkQ9HVEl5",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "-u_p)g36c5.0r5:sJJ__",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "=ZLb:4JPWLDlVSJ_V=.,",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "$#xuj[1+IRkQ8?q_?5{N",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "$EdIwp|[??|*qxA[tR?2",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "5ztW:Kuh0@-(7?Bl1VmV",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "n2`Pw~oeyU~j~g__0b_P",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "[hgx!3[/Om_5#DolHaf^",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "l5SVw1ZaAO!-okXm~bQ8",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "`fI$O[cxKcn[/cXL,(-R",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "8MfaRtv9g2WGdvOt5z6f",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "t$.wQjft#EvER/h/MGos",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "(]}$hjk7LcJ*QXc}FSdm",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "79eGl0q#N#$0y.o}}/BG",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "E=$C#dJ~YUIsY-9m*ads",
      "name": "@Skill/Trait/BlastIncreaseKBPercent"
    },
    {
      "id": "1]H|.pEB%b/zPbJlu.iH",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "BA[{}WK3[hX*RSZFDF-T",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "L+A2@ppo8ZN]%(jz?nUy",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "l8U}pJ$toM%I^{kK3+TD",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "Q-XKnD)o7AQwr3;?v!aT",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "|!b8iG(M(VIV)K$6g1,}",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "525gpV%Ok==cw*aTu*fh",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "Cl`oa]?g-e6R$.dWZWP8",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "3yea93XNypf0CHs+s)Y[",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "tbx3oWk*@fKa=12tZR34",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "fPWz/[x6NF8_QNmmFMc`",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "?+!44P*f}[Dk$|+y1-^6",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "mhMfXe$$w*3RHC!N`^kj",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "F$.Y%y9-[I$bmgP*^5Gl",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "![~y){{^@nkh5JgJj7sL",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "YHurqM`PFdb8gm]ZHjfp",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "%AF85{0@2?1uUkQO*YH-",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "]6JoI5z:+tp:c-I]+g1q",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "y,`1I%CxMiCPAuz#Gb@6",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "kzwbp4H9FOc?]*_ECI9/",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": ":Ez`6nL3:0w?f`_biNz4",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "XebVxbLr@5Hv@a3#uf%K",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "I1G{g1Um`W*.pWfza%Py",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "w%s;??BG~Hsah9*PsZO^",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "03g(nOV8-=NNZ%vi6aC+",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "iA}v;WTpUQA{=Cwl0Tu;",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "F/DFvtJMr{4nK,U!c?Uo",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "Z[?GZ[Di^,5:xwy?rpmr",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "FeCYXOPMxG[[x%YHS5yt",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "xayo(z(x92i.$VdBe;So",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "P)6QAIAoRNr~aIJn6cfh",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "]a1TI@QH/@IlYrQZqUB|",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "?1H0sLJ)c-vwxd9%2cxQ",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "S*,}?d4/oXa)#{G0))R^",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "f]@C!uZ;MM1r~|wY)ts;",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "o_Au~0kz{B)jvWr1t#h]",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "%QX32@Szj7;pIw::8)QP",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "0|ZwEhj)[q{2G:uQS5cT",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "Xxx0OJH1c`^(05}4F~H-",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "=)fsJA]9C3e#nf;hZJ)#",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "V.H%rkM3b)wl9Ge8lO)[",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "]S6VrNV@:Wo-LR.[/(aW",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "B:9_aMvzv1vp}9kGuQ{)",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "Th/a{mayUY$c]?},es5d",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "VG1-:QYv/{rRnaO{KP_o",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "j@(2!+w)yk;bfe5oefo)",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": ".(!a(TF`q!6u%BI+W+df",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "a+c{$gaaz!5I*tSkp}:M",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "1TdmPlgxB{3s|$gk%37M",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "qSHJk.R-ZQUYk3?Fk@42",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "voL;Y`6IoinTqX^/43]J",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "N_${3J`3aoHDQ84h(H@0",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "6y*z_Dbgsc~#U9W6WslX",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "@iggL?1.09jiyr![j33=",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "S:n]Ruh@=5kc,,,Sv]o3",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "ShaaR({7qN#kLX4.s[bI",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "966ARbhJtAN{GU2I4ZZM",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "5*h)p4YA(}mT#r}}KbNE",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "ysxyL)W+NBS?rVx77u=?",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "k|W:,|BdWGgGKA6?!y_u",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "hgf2I%hrjLg[`K9MUG__",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "p3OUSjTEQ(Z%zNG=5W7j",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "Lg^_-c:hJ!DI@g@TPA?f",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "x[tT=?BWtW:]Lm~$:p-#",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "?cidD|c3T=g$A!pxlemb",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "x:HoGLZw^vEQ8U;G?p#m",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "P#y~=7@PM(jp?IZZ#yum",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "@nc~8:[iqi8@c=Z$HRQ%",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "z%Fod#(*^HpK*6@AgRJU",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "Gv%|%?BvBgV6nzK.~e[5",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "A5`fbH!Nd,C)Y_2T:*0P",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "TLHDSe$s:x,r@0=*JX,:",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "nk{:%.pV.qBnPzzQm+bI",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": ":KgILWQm/}AM~(:q@(DV",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "~Llw~8l@7bonawC[2hyR",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "DO#]X/Hb*HCveDtlhlLe",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "f3fqpA`%NJe(b3zrBc8A",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "UJ,+(uz*Z?mt0{;Q*q^a",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "23Zgy%y]wNn]B[9SQ2Iv",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "T-9l`{qed$iEwuR?80kY",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "?u|LU@o^e7e[I7+O1KlV",
      "name": "Gem"
    },
    {
      "id": "0f7h:w!TIxUG$dxlf3}`",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "?A|!IPLYB:04F#jL;9~P",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "}b,SlH4]Np#``)Z1^JtR",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "UD66F8=g]pN%rYcK@|Tb",
      "name": "Map/IsStart"
    },
    {
      "id": "S-exJAtl,SgglO:IZdc0",
      "name": "Map/Wave"
    },
    {
      "id": "#w8Y1xYUGx#Z}Fo)V?)h",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "Oge%2St9wjuKJk22@9$Z",
      "name": "Map/CanStart"
    },
    {
      "id": "{.DF#0V_YzF5*6=ttdLT",
      "name": "Map/Wave/Step"
    },
    {
      "id": "S/]KGU1x~e#dtwP9*(Q-",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "I(ERV^Xz^SR7uGC.J!7t",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "yR:4Ml5*YF)OgKO2|M!b",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": ",tA|Bj/!~Z{Lk^4E=|*_",
      "name": "Map/Wave/State"
    },
    {
      "id": "JtY?FRQeTc0c[v^*XSZ}",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "z|m+Mu3VGo@.^Vd{SHqx",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "mb%InwUz$91fC]}hW^U4",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "N2a.xgjO^Rp~ZlD99r/Y",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "eSX/:M{v#kwFp))bw$jS",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "4*TYr/;E{HgI3WBOL.pD",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "8V2aO/~K5f@CyQGYO1lD",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": ":Xq5YVgDx~{pG;+=zOUV",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "K[`_1F?I]nms5cL4na`A",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "|9bRk2-d1uR){,1;_=8^",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "{2Ba6@gS4,0l]R[ZBff0",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "F,7T9f[7A0h|P5u(2!R^",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": ".Vdjg{}eV/_]Py1G1iC~",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "#9={sj9b1rmW=rw08tcl",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "em-](J%gq!o/x114/yU|",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "[A{6wfHd;B[B=:B~GfOd",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "2EKXUXJM[@B:.D)jl29{",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "+1q)mIQ(25aou0TF6ikv",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "_)*;katL8Rdjt:WlY38a",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "(dB(rWy;*1VPS}^6EZ_6",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "JGd;l)%DcH$A3=6yY,!m",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "I!deKmO/GB+d*NvXoZCZ",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "?)~AKVF,#EW-b]!K@K@x",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "W?t:T4:)q[5/]t,{uTPh",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "Thr6NM;-lD#L2delinZx",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": ";wLQBgr/Kly2Y{jG9Y4u",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "Wv{dA+(Pm@ye6woO6TwD",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "vrpwIfP9DB?__dNv:[2A",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "%G/oISI64)a?Ry[L2#0Y",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "Y-Shq1Jkrn;l(kNp/f?Q",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "Ug:2X[A=dREgA#gVD+8S",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "[!}@?vxhG#8K]Z$/:pX6",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "^XDQ2#G6Z0Kpsfo4fI_d",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "De3K((gu_CUz(XIAh/6@",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "!1cr/@QIhIY3b:vXfXg{",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "^f,DkY?k#@L{sh(=ORaO",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "[gXm+TPo4lGIGmwJs9xp",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "!-RUGyw0vDqpC@^;S?-4",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "b:1~V)Mj;f~Cg1jl7/0!",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "ISHu!oXKUR:[XF7rO-W?",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "V67n}dB{F}+%k:-L.ld|",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "V3C0RQbI}o@]4Z+(n~rA",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "4m07=y3k5Tqf(}J4-MLX",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "Q%o|HaPfDKK@[]q{ZmJ2",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "_n,D]KbG4gMql+LdERHX",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "gEi.,+q1=Ht.%YZ[tAXU",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "$S8Iiqpw*,;(]MbvF![I",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "dA2){xObcs1XiGrVz|bx",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "[ogK([ep~W.(9.SN|e]N",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "m7[nml[=B;a]Y*|c7?{V",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "LiaTIWz3u(FGcnQ5_*s}",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": ";_dW[F^6axvh1UBt^2!p",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "~TUKxY9+Dh5g/+#Kxx?y",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "K)Y.7z^t5.,b5C8;ILDD",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "$X}Q8a#RYE$C}O!k|p.e",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "gq!GHm-E):[ZV_N+BenM",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "e|t11O7YxJERIB4Qdt,9",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "!~D1j6tM*?%[%pZhSuUl",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "Po.1]~%^jkb}(th)N3DN",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "UIt[Pyj|$FH,a*KW#MJB",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "?Zb`cS41@+BkCJ99Bb$#",
      "name": "Buff/CurrentWave"
    },
    {
      "id": ".eObUL}DO[A[9%t~F*+4",
      "name": "Map/Player/Moving"
    },
    {
      "id": "40D0.tM6KS2_5;mH}hBh",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "zm/N#(m5s[?7u0?P8Tkv",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "?|C~r2$$s4V6aO1~Euth",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "OSWj:ori/siT$zsGN1w3",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "*m,jFf}JzI$/1pkDM~Wp",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "/F]!,YG-XL]{^kq-@6H1",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "09:.S)ehO1%zm?l_mAHA",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "22y;f;FZEPexS?DR(NN.",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "n[;q4Kv9Y[M9PhAzKH6,",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "i4F;YhH9xENH:l_5Csn2",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "(m0H(pf;]293vbJ-Qc:%",
      "name": "@Map/Progress"
    },
    {
      "id": "yCMIC}[EZ::X-]%j1J,=",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "b*P+^X8TSEsFIRt@=`Md",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "!~#awP(b0YRed}gt{mv*",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "cI[W2(AOUMV@Rb~FT#=$",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "dKnc6%?-C7`*Gx8lU94a",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "`AB))M?]M:]F[]7D^h!R",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "^j!)c!Wk3t2NE%;afGgR",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "RUvYf-$7PijfrqD`_:Wr",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "83aAM^$tBTp$gL|EusJ.",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "PcGQkSs9c[mtOQ9n(PW$",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "faT-UD}O1o6}qn#G~%_b",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "_jQ+I#JR0I3RX3~#JY=:",
      "name": "@Skill/Variable/10"
    }
  ]
}