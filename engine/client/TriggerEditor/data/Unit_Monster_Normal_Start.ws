{
  "blocks": {
    "blocks": [
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
                        "id": "Z6v#hqNv.3_qI2oX,G@N"
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
                        "id": "Z6v#hqNv.3_qI2oX,G@N"
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
            "id": "YQxSXSGvKYdbQ+gaD=%Q",
            "inputs": {
              "DO0": {
                "block": {
                  "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "unitMethod:AddBuff",
                    "THIS": true
                  },
                  "id": "q[BR7/{2,.-$-]GLhVT#",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "extraState": "<mutation></mutation>",
                        "fields": {
                          "TYPE": "board",
                          "VAR": {
                            "id": "296Ig;LQlJ1uV^)!{^OY"
                          }
                        },
                        "id": "T*KO-r412Md5g34^(gmM",
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
                  "id": ".%WwL[BV+CL}/U/G/.E7",
                  "inputs": {
                    "A": {
                      "block": {
                        "extraState": "<mutation></mutation>",
                        "fields": {
                          "TYPE": "board",
                          "VAR": {
                            "id": "296Ig;LQlJ1uV^)!{^OY"
                          }
                        },
                        "id": "!oi!jxo[gv=Kc8fPxurL",
                        "type": "variables_get"
                      }
                    },
                    "B": {
                      "block": {
                        "fields": {
                          "NUM": 0
                        },
                        "id": "S^Ei(5O]E4J-lC-+:+qf",
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
                "id": "S7e-j}X}NoapeH1__9BJ",
                "inputs": {
                  "DO0": {
                    "block": {
                      "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                      "fields": {
                        "NAME": "unitMethod:AddBuff",
                        "THIS": true
                      },
                      "id": "J?f$FtN#iF5W}OgYj?,M",
                      "inputs": {
                        "ARG0": {
                          "block": {
                            "extraState": "<mutation></mutation>",
                            "fields": {
                              "TYPE": "board",
                              "VAR": {
                                "id": "yr(0u46OYl#?TSP3)mVQ"
                              }
                            },
                            "id": "Zvmo~Uj`^7:RCAQtUVph",
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
                      "id": "d#u)_twEXL[t$04H1~x%",
                      "inputs": {
                        "A": {
                          "block": {
                            "extraState": "<mutation></mutation>",
                            "fields": {
                              "TYPE": "board",
                              "VAR": {
                                "id": "yr(0u46OYl#?TSP3)mVQ"
                              }
                            },
                            "id": "p(a#V%{F(3}grgdke]8I",
                            "type": "variables_get"
                          }
                        },
                        "B": {
                          "block": {
                            "fields": {
                              "NUM": 0
                            },
                            "id": "Cm??kq0@307=oe~kzDAQ",
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
        "x": 815,
        "y": -15
      },
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
        "x": 805,
        "y": 555
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Unit_Monster_Normal_Start",
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
      "id": "T)E`JxMM73/l5Tbfgor#",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "=uZe/3ntO%24,J|;e-@y",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "AqeJF(b8CZaU53ux/;GU",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "c{U6Yu43Uqg@qJm25BD_",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "-YF$MgH!3xWWnDKKF/^i",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "rGrjAapsRZUYI3Z^N-xl",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "*boWSA)P=(hls*U=.xPY",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "Z/60-gJ-@kIsr|ugyU4_",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "XY(j.[k,[.F)r0wR6]j2",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "?5^vvSkAf5Jp$jFPd!X|",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "nH^!{6ID0Wp%#X2_PT7f",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "usDVP0n.LQJ{hmLBYJ?)",
      "name": "@Map/MonsterID21"
    },
    {
      "id": "U*MiqWtq5{wrRub8`hgV",
      "name": "@Map/MonsterID22"
    },
    {
      "id": "rU*Yx00F6}1qo_DR{oJv",
      "name": "@Map/MonsterID23"
    },
    {
      "id": "Y!fw-aS+P=]am$sfhORo",
      "name": "@Map/MonsterID24"
    },
    {
      "id": "@o[7]X)P?HquS-EaWIQZ",
      "name": "@Map/MonsterID25"
    },
    {
      "id": "99$3AL1dREUp=h57y98|",
      "name": "@Map/MonsterID26"
    },
    {
      "id": "t*:%9ZS[Fn;Z+wCjXssz",
      "name": "@Map/MonsterID27"
    },
    {
      "id": "*e[lmQd%qi?^H]p.zQAQ",
      "name": "@Map/MonsterID28"
    },
    {
      "id": "1_gE`mxi0$C]!=rTdLtp",
      "name": "@Map/MonsterID29"
    },
    {
      "id": "X_X2FuPa~NmGBry=)%*L",
      "name": "@Map/MonsterID30"
    },
    {
      "id": "v1sEs#-cjr5k*MrDfO;)",
      "name": "@Map/MonsterID31"
    },
    {
      "id": "cmn6m#hP%#L)E)tN;L~-",
      "name": "@Map/MonsterID32"
    },
    {
      "id": "zADg.?deL/F8H[Tl,S{T",
      "name": "@Map/MonsterID33"
    },
    {
      "id": "`5JEx}os3d%w*rhcmsFs",
      "name": "@Map/MonsterID34"
    },
    {
      "id": "PxoT[5zbCk~lNa4N`PqH",
      "name": "@Map/MonsterID35"
    },
    {
      "id": "J#2YTK4w4+A/SdSKtVLx",
      "name": "@Map/MonsterID36"
    },
    {
      "id": "E`V_#1kIF0151tKN!l6{",
      "name": "@Map/MonsterID37"
    },
    {
      "id": "[`58D%TP!!q~!~iK/q5[",
      "name": "@Map/MonsterID38"
    },
    {
      "id": "KgoJsveB5xH{QZ;[9so`",
      "name": "@Map/MonsterID39"
    },
    {
      "id": "FFQW2%K)6k})bCGZg!S:",
      "name": "@Map/MonsterID40"
    },
    {
      "id": "x^MYn.xvgjglbz5ZaxMK",
      "name": "@Map/MonsterID41"
    },
    {
      "id": "2qJp$OqL?UfoKX]G,%3?",
      "name": "@Map/MonsterID42"
    },
    {
      "id": "cW$gossxbSl(j$,jn(44",
      "name": "@Map/MonsterID43"
    },
    {
      "id": "Xww!iW}F#Bb@VDLkCCYD",
      "name": "@Map/MonsterID44"
    },
    {
      "id": "E1zX5]3uxFN+mhaU!3x]",
      "name": "@Map/MonsterID45"
    },
    {
      "id": "$EcAafRz].eE*gdkX^K$",
      "name": "@Map/MonsterID46"
    },
    {
      "id": "ldY+pJ!0EZusJ#ZB:0~8",
      "name": "@Map/MonsterID47"
    },
    {
      "id": "X1Ge=J[dD?Qj/!;.r=(W",
      "name": "@Map/MonsterID48"
    },
    {
      "id": "mGT;H_[hGfh{9n`q*fX6",
      "name": "@Map/MonsterID49"
    },
    {
      "id": "u^ICT^rvd3O)g9g*OCqu",
      "name": "@Map/MonsterID50"
    },
    {
      "id": "tb4oZ]5ISwpuwnBs(|/L",
      "name": "@Map/MonsterID51"
    },
    {
      "id": "a2CAQyCba?Gs:K3fWpVg",
      "name": "@Map/MonsterID52"
    },
    {
      "id": "KEdR6;_IR2X7Vzy9Y)!c",
      "name": "@Map/MonsterID53"
    },
    {
      "id": "mE|4;^3}+`nksx%9e/a(",
      "name": "@Map/MonsterID54"
    },
    {
      "id": "36]OhS80yDO]*,5-*bEM",
      "name": "@Map/MonsterID55"
    },
    {
      "id": "=OM(Pk5D4+,_7^=u5Iv:",
      "name": "@Map/MonsterID56"
    },
    {
      "id": "B.odG5QGh4%,8Tt)?~-G",
      "name": "@Map/MonsterID57"
    },
    {
      "id": "B$9V%i_]cn@qd`12!UiY",
      "name": "@Map/MonsterID58"
    },
    {
      "id": "xt{Cgr.|_=hZzgr}UmJE",
      "name": "@Map/MonsterID59"
    },
    {
      "id": "h+]uk[^d#.[/^![$|f[Q",
      "name": "@Map/MonsterID60"
    },
    {
      "id": "81NStZaU,:fV5Q;{iQ.A",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "qO?:K}BgWCq/v|:4@9us",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "(@SeOqj1oKWEwfd?dvMb",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "a`WXJwEbw4F,X!nkORkP",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": ")aK:nOqMyh`+s%/j/:J(",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "%3A1BV0=ZZbL#osW?-4p",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "r6WBid|RwD*3Cf:yaUZ(",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "hsO+yd-K[q$IrOFtv,jk",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "okG[^Y@TEvY-k8x;=Qj$",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "zmIrVM1[MYHrzBHE}Xb-",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "T[mpc)%4y?Ijn%T}cTlu",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "Qs]wUbU/w+0nf-R!e]3L",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "kmH@X5x@[xY~U;^!/:LY",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "-w-(97bcq=191FOAUKtO",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "CFExz7({-dEIGYEcqICN",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "FMqD^F2^PxP+ToG2ao@U",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "X~M(P/l*?)_kd3{@B)Q^",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "Jl;RD-WK^VS?g*,kwHM)",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "QR;EVVN|J1Yd=[U{ZYuo",
      "name": "@Map/MonsterID61"
    },
    {
      "id": "QpvL1A+d@CI)o5e;8H6U",
      "name": "@Map/MonsterID62"
    },
    {
      "id": "AL5^DO!8``T9y8,GbUnR",
      "name": "@Map/MonsterID63"
    },
    {
      "id": "OCM~,x^Z0K@t?*R[-Jay",
      "name": "@Map/MonsterID64"
    },
    {
      "id": "WLj1vdw?xx[.qQ-e2KRc",
      "name": "@Map/MonsterID65"
    },
    {
      "id": "/N=*R_pG`wmgM3B#sKGh",
      "name": "@Map/MonsterID66"
    },
    {
      "id": "8#1X=(j^@P;VcHsC7=z#",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "C?%N|Ll}).Ws/9PRN]*b",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "N#@4PAg%qw^kHh`=UgVM",
      "name": "@Skill/Variable/02"
    },
    {
      "id": ";D|P4g=A`L{S+k.jET7e",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "f7+6j7)Pm++alB@eDU+U",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "XO!2q2stP/_F0~kmGKDs",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "+?wRb*9*9;HK:TQQcYQ3",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "zjpOqjWLTY;hnZ^4f2L%",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "TkIt-=*%{@P~5Xv+8I9@",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "eA__|Iy3j.ge=QX.XJcG",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "`r1%t?|Y5ZwSs[G~Fw,e",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": ",1WLJS%um#_1^j@-O%bn",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "~`CU~n*4pTYmy!FBehb`",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "c,dBnxFUviA}[R0SMnHs",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "sX39bxA;Vw2Ag9ze*[hW",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": ".+hs0z`}gByNiR@qE~,|",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "WzhMihJ.G?WoC!7m/m:$",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "C);.n`ea{lsM}L1MYZ]o",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "*:`oRD${Kl!nlc)T!@n^",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "Vy/R.JS+}%8Y=S5-9bwt",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "_gIlvL{jm@oU?fGiKwvJ",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "RMjj$EBQj?1i*LE0A2)r",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "g`Zn0nCLh}pGlNmLG1HB",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "iN=bO`TNVVTvXLdem]BJ",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": ":@%|W1$!dQWVr4CQBd9o",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "3LrV;QA.,y[{{pgXhd`H",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "%RA7R#C$%p^N~u8oK^MO",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "lREkv^~a%W=[=9-`Uf)5",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "-~Q=)TJj~pz9mF!3~9z|",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "X.{{7,aZ]9^Umi!oAk3}",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "0S7*qMP7En0n9,OY,mUu",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "6-1`Sz0*D}mSc-7szbZ]",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "_Kuw|ae@hs-*lW;i#Y(6",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "N4_?6vriypHcm[k;%?~l",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "O%941%uXU8@[Z64X=(sw",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "A]_mWIevix3Pea-)j6Y`",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "S8#u_5ryWlRC}19Dm0(j",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "+UdODMYxF1rx3`9h-i0S",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "!Ctoh=`ATR$!1ZBCQ{.L",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "-N7j=rXTd~{F^9,^DccB",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "9sBd~K?w[A/GOem2sd1+",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "ApXBbz5c.@F$L;.E/^Kb",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "8l$lLwHZ=npKN`sW+X2-",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "r,pi3uDGjh;omFU.DDl~",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "j7-sAi!vK5c?k?fh13qw",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": ";wo32X[~L:1lEQL[DyMZ",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "vbN8J~5G-:Ll}`3sP/l|",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "7BjYiBom{.bFTBt[6GAy",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": ";Q[e/fvX]Ab+$Bzy,6c2",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "QcidQS%R?N%FZA(Zkt:9",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "$^?29xf,[bB%my.SNIq*",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "G~iWOEoLX-;VBed41=u4",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "wh-rrYo,KiKZJY.^MV~~",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "Zxc*?}*zug)HcC)#N|hf",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "7?i%Pi0s:R3]@{b;15eh",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "w(!0jYP$cl*cG,iL0(LH",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "NZI}FK1?W1mo.^wIpn!L",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "P47Iaxrm3s74ZdFZ[bPp",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "mxP8MO?/y0o4.[d;jB`Z",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "sUMQM}YUD0Q;K1s|~5iF",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "BILoY]H{vIhs/wfuO9IF",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "9=.E][uJgtM9gw9e;N_M",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "xn!KCh=RKI`/M|p%_T?x",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "Hy[+g!k?yW(HW}utu22*",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "8lYB#(r4VFPD^*rkb^M@",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "!}cI)Aw8LHEKAGdCL@39",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "x[rT^K8sZ!H8Cj,/ae{e",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "y}Nv/On/F1Sm88IxN7EB",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "Mcb:Js{WfL]-|[}8/rg9",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "6h@G0nnHT^4-ur=sM6^b",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "I`E2Q:T$oxT1Zd}-4*t.",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "bfROLSB^BoNh(4Gc=Yq/",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "*`D/]S6Xr8_~uk4}[rll",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "9NP]Q/(R;kc%_p(PA~iU",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "2kwnyEoj6+J+!q60t6[v",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "aR5^1=7fAkn_SLuk!On}",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "YX[:xj):CfYnLHIwQd~G",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "?Ux{KA%-Fnu^8soVa(RG",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": ":;0)[Q,fa)SeOuw[vEWm",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "`5iUO6lR-YH=pql{#yI%",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "Qu6fK,VM#^IoZNj~G@Z6",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "vJK`qlYNjMjY{4yw27Ge",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "=AEc~tN),$++kV!B:QZS",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "0Bi)[{:@2W.3YO5(ex[K",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "I[AL:)Fh%{gLhuf*yOQg",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "w](HR$-x1abLOX}[mWfa",
      "name": "@Map/Variable01"
    },
    {
      "id": "!U7z(FU+lT_hO?b`B9N^",
      "name": "@Map/Variable02"
    },
    {
      "id": "TB-Q3e{PQ7cb;!jd-fo*",
      "name": "@Map/Variable03"
    },
    {
      "id": "ADYV2U]gMM,Nw?0omz@[",
      "name": "@Map/Variable04"
    },
    {
      "id": "xgVY?jwP306,k@h?Z,0J",
      "name": "@Map/Variable05"
    },
    {
      "id": "iwiTK%_X;lXMk~05):rd",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "VUk;Bz/p1[V;oNl]Si4K",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "9flwB@z)Mwuk`5C@afxR",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "rmun1`ov{Kc6BoI6n%M`",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "^k2D5Y]ds@a}_L|1C:vP",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "K#:auv~bdjm3=Mr]xkWf",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "Gaef1I/F9d5|N_oD9Kh!",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "tO%@OH[Wj|h{5yW9YC@_",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "IR|f}m;Ql?CTIZQFbnLU",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": "p8U#[zQ+1pVeABDjCRhB",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": "~S@mVc,AejS2?6M]nc:=",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "5uAk$e*P)fm~Q7)p]B7q",
      "name": "@Unit/Variable01"
    },
    {
      "id": "tiZ!?!J4C9mRc?P9QtO;",
      "name": "@Unit/Variable02"
    },
    {
      "id": "tS3G%4+uEv@WKTfpxSx:",
      "name": "@Unit/Variable03"
    },
    {
      "id": "n]?m~+K0zqZ|Nw9!NBl/",
      "name": "@Unit/Variable04"
    },
    {
      "id": "0Z]E$]7-qwIF7hG=T5z5",
      "name": "@Unit/Variable05"
    },
    {
      "id": "h9g:*F{eVtn|$.J7%kLo",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "-0O%qxTh}Ud*Dtt[9JKl",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "}/D:q3]{tL^HFF$mZNB9",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "Pr,)k{uwSJjS#g?1|ciG",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "YI|fhd),_KU+xKprLP0%",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "r;!6$pGFer[xyVX%RR$B",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "th7qLS8A)*bi(peR1[7E",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "J~l3Ea@8r;4OHXEVd`(|",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "a!OQJ~?guZC(7Gut1teA",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": ")N,-B^t47*9VEr;T*e(r",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "z*DDz%12qoTC=j;2OS|m",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "0kNxKg|5V*ku)JEI5F(T",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "wN6Kio`E52n9B%trX6M3",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "Oq+v!b;]cSwB9`]L}`@}",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "}gUkIc.6:a[m^8L@1*QP",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "g}jVtchwG-=n}w_{]N|Q",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "$uL)(qfUE!+kNmaKiFc?",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "1]:xb,BModcb5A!%Wlp7",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "fIUo:Lvu;xIU~c~.i,}(",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "AP!1wWPJ5qW;m(IM0eA?",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "[_B[Aa;-.?Zocd9U6/23",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": ")8Cs=GLbe_qV`)xR`X/y",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "MF@}})6P)`^4almn*-D+",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "!+5LivQC7h/ue91NcBxu",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "-/eG3/[CE|M{|felQq$3",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "TJ:P(#_H|*/P!PMl}FiC",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "TH/lB,@.X9Am-Cp=?fDk",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "_Ovqn:z]hnnO0/X],kL3",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "rZ=58)Nh.5}?ixq74j)U",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "rUaPIBzx2kN+;rs+*W7c",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "O9QQRQ*/bM4WSj**Zm@{",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "kVTp^y9q4(gIrOz]|Lb6",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "^yFcRV8:3r%9u6;I{lWS",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": ";z;fWo8zc_nv#)h=Fr8v",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "YV~/d%D?48Dr!0E1^Qr4",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "ei!?]Mk]xw49)c+A`Du/",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "H_ZJy=.BHJxyGwlEb7n4",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "%.oVQ+sn{)t[v|an8@Q]",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "2lv,Pw^^5vSPC9FxmE!A",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "j/y9c6PcpD)as+6(SLI)",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "`pmJ/FbdEeTgx{q13G4;",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "I=QUXnW`(y|l3z%LAPCw",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "%mZfHg|f,hjo,Rx+bc0o",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "Bd[9g4/?AbCt0ME-2pc|",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "()2]WbFEvs4kDRf#T5-5",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "DMskk4uAJEVY{/#iS}iy",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "U@z0_~uBT~u$#w!OVSWJ",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "p]S%I?*pcg=q*,myeyJ;",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "Mc3#a`?P+anPQLyU|T%q",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "[Z_j%a=}-~8Gy/DqA?#(",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "$a/Id90MFJkE,ZUod]A@",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "S-eG)e|T8Y~4H)uuw3xq",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "dJc0~j5oiyIAGpq/-xJ)",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "?gS(W5OVS%wLs1^o$qzQ",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "%q)BftzZmK7A?qS8DB=]",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "FO)POAx4u~p7Gt[F@~H3",
      "name": "Gem shops"
    },
    {
      "id": "0Q[ck:kLwGgb*-~IWRB=",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "Y,QCk{*mUig|-J1yny[3",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "H?i,o+TY05|j#U8JU|N;",
      "name": "Map/Wave"
    },
    {
      "id": "H/]*3e`cUURceDt7C8fC",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "~dXI`{;Uw-}0uP%d!aG+",
      "name": "Map/Wave/Step"
    },
    {
      "id": "4T@bCBhlU.8?5wAFIVw+",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "4%S3Z{2~K$.R#{[YArz8",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "arAUQl6*sm=a.Qc,F83R",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "0;kl!wq.kt=@0yy%f9tf",
      "name": "Map/Wave/State"
    },
    {
      "id": "4BRIRzv?^@dvs6NT[OA.",
      "name": "Gem"
    },
    {
      "id": "ubT3LL[-e3TQKu]Gx7x/",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": ";a67,fT+ThG*M*C0#F^:",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "F$:o[#VbGMiH$ej^/@-U",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "kmpZ:%Xs%fkvo:[RpKqM",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "L?`:8{t-Y.Qo3jPv7*Vv",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "p#uhf4x$=^tjE!ql~M*u",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "01%^aSQ9)@^.vMWV?!ng",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": ";?YZcQ`31LExmjxVv`+m",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "-C|FlYdENwF},3?*rYES",
      "name": "Map/Player/Moving"
    },
    {
      "id": "Bm%Fz0qF4iH.oJ7/#|jH",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "N0?(e/T7(1mqeVj40*.U",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "yUX_hPS%sSJSyf%Ey=(b",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "{wz^*=Dce1do~=9kB*sc",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "E)E$LBq::,ZYuP-6#CB?",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "R%:/EL)[RIGMwSIPx/A2",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "Z6v#hqNv.3_qI2oX,G@N",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "296Ig;LQlJ1uV^)!{^OY",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "yr(0u46OYl#?TSP3)mVQ",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "}cN(1xCxU~U:)*19((*!",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "Ivww;MY-*4uf(+fLo|ix",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "_{G4wUjn^Mh786?1?t-t",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "ysY7BMKPJQP)FH}PFPq7",
      "name": "@Map/Progress"
    },
    {
      "id": ":MEQj)4#~G:!_qy/lJI*",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "s+R[)tjE-F*tMj){^G/*",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": ".}vu*b@4kxmF?6Tc,m@n",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "h-^ZqgaY2$Bk|k*p1E;9",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "bjz=r,7w.Ha|I(Oa;;+$",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "PNLt3WN4(T$~I+8N3zM9",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "[z(tlZfz,%kUTC.YMzH_",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "/h_nJo?w$Y1G](*.dY%.",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "SkupHn*5J*}ZV6_=;hOB",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "ohstGdDgRg[vB:I#IwIp",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "u#p.BY=jDW)~}3lM_@DG",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "k3~%OVJ)A6[Y6EcABtEy",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "dq_dLk=B+5WZ*y!6PY!g",
      "name": "Map/DisplayWinningTeam"
    }
  ]
}