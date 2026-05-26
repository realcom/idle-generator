{
  "blocks": {
    "blocks": [
      {
        "extraState": {
          "hasElse": true
        },
        "id": "ZhL.PRH:~LPmh+a?9f[B",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "THIS": true,
                "VAR": "buffVariable:Enabled"
              },
              "id": "oj}r5LW@~S,]_PFNQ4Yz",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "BOOL": "TRUE"
                    },
                    "id": "}m]RWL6WWCiUF,Ycaw?m",
                    "type": "logic_boolean"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "THIS": true,
                    "VAR": "buffVariable:Level"
                  },
                  "id": "K{C{Uuu^)_0;v@lV3;85",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Tag (필수)&quot;,&quot;name&quot;:&quot;ETag&quot;}]\"></mutation>",
                        "fields": {
                          "NAME": "unitMethod:GetInventoryItemCountByTag",
                          "THIS": true
                        },
                        "id": "L5$LgASM_}RUg?Mqy7vV",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "fields": {
                                "VAR": "50003"
                              },
                              "id": ".!`~g[Vq!?nCW:3vC1t[",
                              "type": "tags_get"
                            }
                          }
                        },
                        "type": "function_call_return"
                      }
                    }
                  },
                  "type": "variables_set_reserved"
                }
              },
              "type": "variables_set_reserved"
            }
          },
          "ELSE": {
            "block": {
              "fields": {
                "THIS": true,
                "VAR": "buffVariable:Enabled"
              },
              "id": "6eyTsCQ!uztsWhE|Z]SY",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "BOOL": "FALSE"
                    },
                    "id": "%zvCPKLJNYRCrp0OsuDk",
                    "type": "logic_boolean"
                  }
                }
              },
              "type": "variables_set_reserved"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "GTE"
              },
              "id": "y,Un87M{GE@m.vPJDr5v",
              "inputs": {
                "A": {
                  "block": {
                    "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Tag (필수)&quot;,&quot;name&quot;:&quot;ETag&quot;}]\"></mutation>",
                    "fields": {
                      "NAME": "unitMethod:GetInventoryItemCountByTag",
                      "THIS": true
                    },
                    "id": "+-@cBJ@LlP)%FtkBx9^i",
                    "inputs": {
                      "ARG0": {
                        "block": {
                          "fields": {
                            "VAR": "50003"
                          },
                          "id": "l]=ubz?v8?L[91[Dh_S5",
                          "type": "tags_get"
                        }
                      }
                    },
                    "type": "function_call_return"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 1
                    },
                    "id": "hs{8h!?p3,:@ewm4Z/Xj",
                    "type": "math_number"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": -3035,
        "y": -675
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Buff_SetBuffPerConsuambleCount_Update",
    "period": "15",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": "R]_qdl8}6ys!(_LXY56H",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "Z8[|MZ#7{DXj{C}mRMY#",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "jP7~Og7m%Z.P)DW21+v~",
      "name": "Unit/Time01"
    },
    {
      "id": "ZjlU`8iYT0:aDR}Q$-(s",
      "name": "Unit/Time02"
    },
    {
      "id": "3=O%E(ALv%~j=vW).2l,",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "gezKBe8%%B)H0/(hxo4)",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "v$jdMVn4XgDd]Fd56efY",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "m8i;ym}6^l]Fvk_l;Pua",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "frQRb(HC4)W{lO@JOW8s",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "4r5FoQ4{0iyCRw*ZT6,I",
      "name": "Unit/Tick"
    },
    {
      "id": "`0UJT6;d_:cw@OBg^|d6",
      "name": "Unit/Rome"
    },
    {
      "id": ",d;j8Gz*CF`?p7=*DZm9",
      "name": "@Unit/Delay"
    },
    {
      "id": ";Qw(A:4tO(R)vqKn!r1M",
      "name": "@Unit/Range01"
    },
    {
      "id": "@g`4aJ1;M3pJG3V}E3{!",
      "name": "@Unit/Range02"
    },
    {
      "id": ")T9wfEk^GYO23HKiqYX~",
      "name": "@Unit/Range03"
    },
    {
      "id": "$2wYG!ai67o:Rc.L%9)w",
      "name": "@Unit/Range04"
    },
    {
      "id": "lh+=3y~J:|mQToH-)`cK",
      "name": "@Unit/Range05"
    },
    {
      "id": "1RAOnV$?JlL}v:wr1IM4",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "?-4JGSh=O,B%6s|A/~Wi",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "b:h:$H?{#][wF2;FyYC9",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "#p{r%kFplNYDiO%~M.e1",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "@M70d|LhBAGyxe4ja9I%",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "7`FK$qZ`*{sor`Yi^p4s",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "LS_u#EwQjt|,xCVdzX!+",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "dNQ(kujOyy(]U@7`ci(I",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": ")(PHv*JAU%dcW^;ml)4*",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "DskpWW=]*1qV+Pb=0_ir",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "n;{91THz?.ZPFicEY!fC",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "XQO|AT?)H|46cov%?{(+",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "2h5-l3l5~Fecf=-N)O#j",
      "name": "@Map/MonsterID01"
    },
    {
      "id": "+QqNaL0wzsqkD*/RlZOv",
      "name": "@Map/MonsterID02"
    },
    {
      "id": "vj)6gAavs1jL48]V5?k)",
      "name": "@Map/MonsterID03"
    },
    {
      "id": "w%!I.a/mz[%,w9)hZ~1R",
      "name": "@Map/MonsterID04"
    },
    {
      "id": "^o!BBAJ@cW]KIqE0U^]P",
      "name": "@Map/MonsterID05"
    },
    {
      "id": "J(5a_U4[]l@T#Qfw33|v",
      "name": "@Map/MonsterID06"
    },
    {
      "id": "r9P3F?}:0f^)({CZmt!u",
      "name": "@Map/MonsterID07"
    },
    {
      "id": "Z^~SH9N;HUf0*45-)j-=",
      "name": "@Map/MonsterID08"
    },
    {
      "id": "]]M/LPNt`J|^$/oAf?8?",
      "name": "@Map/MonsterID09"
    },
    {
      "id": "mM31DIXxPU3U=oqU[m:v",
      "name": "@Map/MonsterID10"
    },
    {
      "id": "eHJA/ms*bH1ha!;pOlbU",
      "name": "@Map/MonsterID11"
    },
    {
      "id": "oeP.sKGT{n-x[dpTwzMM",
      "name": "@Map/MonsterID12"
    },
    {
      "id": "OmY}U4L5g3J3w^_@J7aN",
      "name": "@Map/MonsterID13"
    },
    {
      "id": "nL?OkLS6,X#7RF*jL6gc",
      "name": "@Map/MonsterID14"
    },
    {
      "id": "tI}0x:}cP^VBRE[Y#+:)",
      "name": "@Map/MonsterID15"
    },
    {
      "id": "[SR~flBf/qiGQU4qX(~T",
      "name": "@Map/MonsterID16"
    },
    {
      "id": "fF]x4mkrBuOVyaO$WNzp",
      "name": "@Map/MonsterID17"
    },
    {
      "id": "vo[+m.2:@{!WGqsS*#((",
      "name": "@Map/MonsterID18"
    },
    {
      "id": "-~_piW0f5kRzTwAn1t%x",
      "name": "@Map/MonsterID19"
    },
    {
      "id": "Ctl/.w/au4jZ55-nD;H/",
      "name": "@Map/MonsterID20"
    },
    {
      "id": "BEiu2DTgP?+s$0tQNL9Q",
      "name": "@Map/MonsterID21"
    },
    {
      "id": "Fcqp.{^X+K#vZPjsrIT+",
      "name": "@Map/MonsterID22"
    },
    {
      "id": "pd{8MVMiqbn^K.LZI)-}",
      "name": "@Map/MonsterID23"
    },
    {
      "id": "Sj2$Jx*_715=YCbI4,cG",
      "name": "@Map/MonsterID24"
    },
    {
      "id": "PFDWevf]Bp]p$l!vmwrS",
      "name": "@Map/MonsterID25"
    },
    {
      "id": ".}Fzy5U:{f,Tdu+c/H?L",
      "name": "@Map/MonsterID26"
    },
    {
      "id": "8V8J.zi7God)VJQVSs=+",
      "name": "@Map/MonsterID27"
    },
    {
      "id": "CNI+%~-O`w?}qd[Me,YU",
      "name": "@Map/MonsterID28"
    },
    {
      "id": "lcO,KOU9A8PMxidP]t#*",
      "name": "@Map/MonsterID29"
    },
    {
      "id": "IBUsVgV4jnQ|j;0_8~MH",
      "name": "@Map/MonsterID30"
    },
    {
      "id": "Y/R_nbLe$V[8YMV@4j-V",
      "name": "@Map/MonsterID31"
    },
    {
      "id": "9}DGxsu_y@)e%mZ:3,a2",
      "name": "@Map/MonsterID32"
    },
    {
      "id": "a#-?JOm)jMU+/6h+{1)X",
      "name": "@Map/MonsterID33"
    },
    {
      "id": "#mG/9sQ:.Z?PjITX3n;}",
      "name": "@Map/MonsterID34"
    },
    {
      "id": "I09cQ5RVDgAx-OjpAO?[",
      "name": "@Map/MonsterID35"
    },
    {
      "id": "tFf1OEp;p)jzS8;H!8mF",
      "name": "@Map/MonsterID36"
    },
    {
      "id": ";(^Guuvo9@uI3}~*J9)y",
      "name": "@Map/MonsterID37"
    },
    {
      "id": "$^gLRP1mb6I+}IAO1iTM",
      "name": "@Map/MonsterID38"
    },
    {
      "id": "@pB#0A}h/4:V:EuNcm(`",
      "name": "@Map/MonsterID39"
    },
    {
      "id": "gDQ9u%Lb,1G#_/0}*VHw",
      "name": "@Map/MonsterID40"
    },
    {
      "id": "uEWDrq2Uj1z;I.(me`W2",
      "name": "@Map/MonsterID41"
    },
    {
      "id": "z)=Djd13Z/Rq@a|srnjg",
      "name": "@Map/MonsterID42"
    },
    {
      "id": "+H(-F~`I2ntt|6]x`5L9",
      "name": "@Map/MonsterID43"
    },
    {
      "id": "t@MIRpuprmgHN90^M8[|",
      "name": "@Map/MonsterID44"
    },
    {
      "id": "or]w-Pmq;@vZp6lUa|PU",
      "name": "@Map/MonsterID45"
    },
    {
      "id": "+|U`QmexJbL*cvgL(Rjm",
      "name": "@Map/MonsterID46"
    },
    {
      "id": "1rHr,x:D5ZY7afZ1Xy2b",
      "name": "@Map/MonsterID47"
    },
    {
      "id": "8;G[:+HTN,X#(FF4)|rG",
      "name": "@Map/MonsterID48"
    },
    {
      "id": "dn#K0k`8)DT{QAszfZM+",
      "name": "@Map/MonsterID49"
    },
    {
      "id": "-?,`:Mp|l:SE+F#%,8BW",
      "name": "@Map/MonsterID50"
    },
    {
      "id": "WR}{%/v^%(Whsh_#WHWH",
      "name": "@Map/MonsterID51"
    },
    {
      "id": "C|`E%hqN-LvImOO{Ra($",
      "name": "@Map/MonsterID52"
    },
    {
      "id": ";7n?BTf@nH2+5arMI|nq",
      "name": "@Map/MonsterID53"
    },
    {
      "id": "(8x_!AvBF-0g~foDuc$x",
      "name": "@Map/MonsterID54"
    },
    {
      "id": "%a?5`Tu)/1w@!{2,x(Qc",
      "name": "@Map/MonsterID55"
    },
    {
      "id": "K2lT8?6??2t%)8rY`F#J",
      "name": "@Map/MonsterID56"
    },
    {
      "id": "1Tz#EklR?}`Qy5Vq(9?~",
      "name": "@Map/MonsterID57"
    },
    {
      "id": "cfMY~A?8m7+KajU}0uoe",
      "name": "@Map/MonsterID58"
    },
    {
      "id": "LH1yL.M4OB,%/O5Q3B=6",
      "name": "@Map/MonsterID59"
    },
    {
      "id": "TKo3Ji%ApMT~j%|6V^]s",
      "name": "@Map/MonsterID60"
    },
    {
      "id": "j+ZrzMtMS#bY[Pj?~pLe",
      "name": "@Map/AddBuffID01"
    },
    {
      "id": "-eAcRvN{UYB3:%8zzuI=",
      "name": "@Map/AddBuffID02"
    },
    {
      "id": "#m*aY%AQt+[OZI6z4--V",
      "name": "@Map/AddBuffID03"
    },
    {
      "id": "l~4576izyK)APYe.g^Pg",
      "name": "@Map/AddBuffID04"
    },
    {
      "id": "/-ntygXw41[PG$y]!G=@",
      "name": "@Map/AddBuffID05"
    },
    {
      "id": "M3-7Iy@Zo}TF^l!{R=:K",
      "name": "@Map/AddBuffID06"
    },
    {
      "id": "|$jDps#Ew`|nx7%EGH%B",
      "name": "@Map/AddBuffID07"
    },
    {
      "id": "9{h|BrDkTI8lr`wl79^G",
      "name": "@Map/AddBuffID08"
    },
    {
      "id": ",IGvY8m/~kogTEIaU[y`",
      "name": "@Map/AddBuffID09"
    },
    {
      "id": "v.nj8`a}N2|X@|N,WI;@",
      "name": "@Map/AddBuffID10"
    },
    {
      "id": "?kL(C{V%39RXs+^3,(Gr",
      "name": "@Map/AddBuffID11"
    },
    {
      "id": "|p,uWx~4m+~!U{x(~bW|",
      "name": "@Map/AddBuffID12"
    },
    {
      "id": "$$!.ZB87/U-4+CdsR@aw",
      "name": "@Map/AddBuffID13"
    },
    {
      "id": "bFbT4)Vg7qMhjI9bo~j?",
      "name": "@Map/AddBuffID14"
    },
    {
      "id": "jJ$@_aJCJM|#gc-R,9YD",
      "name": "@Map/AddBuffID15"
    },
    {
      "id": "$o]p_V.yi7j:E:Pi*dIA",
      "name": "@Map/AddBuffID16"
    },
    {
      "id": "qE4nKAO-6KU+]]Bld/+9",
      "name": "@Map/AddBuffID17"
    },
    {
      "id": "]+m41Q~x4XZPl1lb.aI%",
      "name": "@Map/AddBuffID18"
    },
    {
      "id": "lRYG63%psfL7%!QDR!a)",
      "name": "@Map/AddBuffID19"
    },
    {
      "id": "AXR1d/Ni-xW=g?e[$^tI",
      "name": "@Map/AddBuffID20"
    },
    {
      "id": "3lcVY~zCpGX2%2fo@lMv",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "[tbFSD8J{U[tgG{Hq1E]",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "maR7XO}7V.F+gSR=wTN;",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "4,.LJ?)e{wiQfm1~=l9I",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "k3eP8Z?U95Tp3aAwxSix",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "]=xU$[D2?qQ)5Zi/|Kfj",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "Gw?_F2zcfDHI93!wo6oJ",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "cBZ!!q,;););Bs#nF~;)",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "Te0kQa+TS3RmXtiOkyQ/",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": ".peR8S,[z:F(aaJ3`Ob_",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "#lH)naIL%Ip[z65F0gIQ",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "oBc`}ybd32LrcV;a]|S*",
      "name": "@Map/MonsterID61"
    },
    {
      "id": "8}.}W#4SDrx#%*~x~RJI",
      "name": "@Map/MonsterID62"
    },
    {
      "id": ".1QQ%3!dL5L?vPTtz5BM",
      "name": "@Map/MonsterID63"
    },
    {
      "id": "[dHR~NqTs%pra6~pK)-W",
      "name": "@Map/MonsterID64"
    },
    {
      "id": "~KY/m[?uu|u){SHFhCB`",
      "name": "@Map/MonsterID65"
    },
    {
      "id": "EJYl8]qUaG$Ad.bV^Ql+",
      "name": "@Map/MonsterID66"
    },
    {
      "id": "7)}1prZ1EkO`QCpho.wh",
      "name": "Map/BattleValue"
    },
    {
      "id": "{k+,Ed%3v-7,r77WC:8n",
      "name": "Map/IsClear"
    },
    {
      "id": "u1ES7M/ER#)iu2g/R;n~",
      "name": "Map/WaveCount"
    },
    {
      "id": "P7(WcFXfdVb9mvh`y3Qh",
      "name": "Map/WaveTick"
    },
    {
      "id": "yi!l95cq^r:h_fLx@2q^",
      "name": "Map/IsSpawn"
    },
    {
      "id": "!=Mcf~5*(N=U_(BTqO)i",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "W?0Mydl|8tFf}5eY2@7,",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "vf/NG^wA;a%e=JNbE..S",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "Kp|QU0FlR6kJVX4mM/9;",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "`Ur;Zq~onJul-x7Tdvlq",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "XmvZ:Y_$Jl%@$]?:9IIx",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "QC-l*(`%k7(5!k[K3gFS",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "KG3y1p!*9O+0SE*%8PQQ",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "K=k27@c?i{Y@-BjWq6[C",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "l;CJa+PRWb~K%c#4!,):",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "}%{L0!oVD-[6P_QGHyOy",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "1eV%s*^OG=[g|8ghzkN|",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "6fArmk$/Pl%C`|I)6*E9",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "|7|tergn|]jesM!NHPNj",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "i`k=UlId!J-lU/C+zg!Y",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "a-TUnY0Mvu;;4B,Xs^2@",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "I4u9W8$[9v1U*MhK[.Sq",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "Ws5*u,z0~uB)N^8-Ktya",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "a|+5Y5;M)U,Zx:I2ar/s",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "WKPmGvJgZ_vAa%^7,9.w",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "w!V(JJ]bLac8Rn(RCihC",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "nW;YtzrJ05G!2$(`cce.",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "hT96{MnANP7I%~#]RU:.",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "TT$J7#6P842*re]L9387",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "jAwjL0:eC{;Q4!14h,::",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "X_|)zW-MC2^om:J!`Q;[",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "l{87Ajrfr{-YBHP1+6MR",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "Uw*N0W,thew($T2x$pN9",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "E[5mT=G.xm/z]*qYQ^)D",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "Y+JM_I$O[g.Bs-rk]1oP",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "6Yy.kW}#1qWW*;SaGv:F",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "KUoCBaC;sALAyP6}zZg9",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "wa+w}H$4CLfQDcwI*K(V",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "NgczM3`9eZIOrS$m//Vk",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "[920t#r#hv6Xs`hE~,`4",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "dS`62N|4%~/:8S-3am21",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "cQCX9/y-`mLE${zEqbj_",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "Y$5tH:CY(krx`n`j2;[`",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "7,)cTWp{4DpX*958:]Z6",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "|%PktK`jL]Y#_YKVUt0.",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "6hJA@,*y;K)`Kv-SF(C8",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "Qz~Jrq|bk*x(r=:8oyq-",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "ByC,25$2Cy+]]n4BP/eS",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "-gc91)QI`kWfo{R**$aj",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "pqCG9Q2+0Z^f:=E|#:XU",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "2Z=(=V.otfWf,I^T}]ww",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "Jc?y$(bRWp2[)n[?^M|W",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "*6^P8*k7LSC@+8ijG:*}",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "jKWOHQ]E$+/U0n6](}A;",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "?V4%{d:3It)tSJqk*`Ry",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "59fI7F54v+uC8O|/l8$r",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "1IBgb;nb.tDF^jGx=0EZ",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "2O^V**Q^8s|A]cQjBLUC",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "x;e#NIJu8lu*:voJ7wL6",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": ".#zUgpdOy]VXG.a-O42[",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "9TkUI6mJKQXZMqe/R*3y",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "3VVf+o{ddSt9sGR[a_Fx",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "G89L^[PpzZ_j]t]1hj%o",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "#zueFW0JyWX|an9Hd4Ob",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "OsheB6G%UM=3Rv=.m%`U",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "zV/B:WV^59Pl@esr:uok",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "Ofndw?sQ1{.Dn|z1?$)r",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "IqJ~{YCF(P,34)n5|j=6",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "or,(ThvGULKpbSw3-K`S",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": ":lq$h5En6[/47nmt@Y,`",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": ",VK`(~l2,X/GZf3Cx@Ac",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "OrfiL|D=!w74q]B{@Qv;",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "99U:j,^Qji4W5LlymG,D",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "kYp*Qn%5scw~VQXkxMCT",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "z]RTtCY_lq4PZ9wO{5JZ",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "Rq65|q`F*B#}VFgD9.c;",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "3T{.$k8auV-L.asDC~k7",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "4g*,6i;Eq*~y@oK.:Grv",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "}aC5?`Es):H#@Vf.#Mi`",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "f[|J1g+`7LaUN[u@qxm)",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "G/IY:q=4$P-Lv0^)~O`V",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "S`^,Bv2+y-vU72d[0V7y",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "%@O@ibdK#VNTeT`k2%Mk",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": ";fu6w7ih+XELU/1b{zt2",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "X]5RmP!B!blXC|SuX,9P",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "`!+fkCXW73~+0nE.vmU?",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "[F$R%8W!npSm3OX,UZ./",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "x%$|[9m8[f5oBupR@FKU",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "^/#=_1T7b`:H8]K%!xeI",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "e!C*lVvGKv.s2NV`etHi",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "2GY}]5x]Did$fo}yGoiC",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "U[Fu.sm?4s5{tGvCAFrC",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "R1w4~I7j!{e5VSbql4|+",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "eGC/TN#i-2:bO=(K-_we",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "HJe8^y*(C~Tk;XSXyVGi",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "DSz;kRf5,?]%XpK=Oz^1",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "~:[ap9V-A8b^#S!=B3K$",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "g89Wwo|WRrBv(UJaVA9y",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "~!ac~hlc0,@7a3k+*`v@",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "3I=BW=NcY{1M#lpV|zNo",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "7-w*Yq$3;?,PJ77jwrhh",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "a!rM2bEJ=a.`#{%Bu%s~",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "N3SF@VIwrSw,zXn,lV1!",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "3hcfWmp=D$.#+W-C4=-?",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "F[3i7fY`M72)bcaV0@Gv",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "G(zS`{g?T{i9xKt.T:ab",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "B+a~XST@_+3KJw/`]9;m",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "Y7S,U:6ZQdeLjwG42]9G",
      "name": "Gem"
    },
    {
      "id": "rw$S}y.o9`5lIXSc9tA4",
      "name": "@Unit/Variable01"
    },
    {
      "id": "Km(HafJp#Fw^]?s5o4-u",
      "name": "@Unit/Variable02"
    },
    {
      "id": "x65@Tdg|~0SpIAe#VHt;",
      "name": "@Unit/Variable03"
    },
    {
      "id": "0`|7K?C_@f_7W*U`Q)cm",
      "name": "@Unit/Variable04"
    },
    {
      "id": "WNQj}(a|fUEG2$KV9=(H",
      "name": "@Unit/Variable05"
    },
    {
      "id": "GH!B:`A#bN`xUwOcWT:C",
      "name": "@Map/Variable01"
    },
    {
      "id": "2!Gr5T+!?@f-bPY~q1lS",
      "name": "@Map/Variable02"
    },
    {
      "id": "!6VUaFJgwje85*pc@7aM",
      "name": "@Map/Variable03"
    },
    {
      "id": "eVg[e:DtKAC#70]_Zv.w",
      "name": "@Map/Variable04"
    },
    {
      "id": "$}q2iPKxsxM6jIw[O79#",
      "name": "@Map/Variable05"
    },
    {
      "id": "J*s1X4}b!TWT;R[G;zwX",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": ".+CHHjMRozbZyqnS5/j-",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "2fb+ABvlcs2?*3Q@|D`z",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "$fXl6@KZ.AGoE2toRU4P",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "-/!-fUoD@mH3kCwG-({Y",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "9u.TAu]uu0(Mf.So|@{5",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "0hBW6^fD(UByZT%A$42^",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": ".hBUJ$tlCYReo!.Uoc$y",
      "name": "Map/Wave"
    },
    {
      "id": "f.sB{W9?OiAt1E?)y@`5",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "VdLT.S0X^hPBl^yrv}yV",
      "name": "Map/Wave/Step"
    },
    {
      "id": "Dw]z;`lQh[m1Yr5y*0p5",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "2iQ]VwzBU6)mw54w?F78",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "6QpFS1YR%YJ_X=;i.BT;",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "T9UXd0Z8@^5V.^G%N.2-",
      "name": "Map/Wave/State"
    },
    {
      "id": "k(mnBPg;MXhx09v7+=_Y",
      "name": "Map/Player/Moving"
    },
    {
      "id": "V*#l0{o0yrIOb,c@nF^6",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "xcF9O[*+~fl$arch`NE%",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "M3!*vH$LI8B/+%-]a5%R",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "9J:u:ItdTiR{?}x-^0El",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "%J1ULRo]5t5tZ)Wm78t.",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "mJ-DHbceQ^I?#X1Lh_L+",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "2JKHADffaoBwEB)dW-L#",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "?p+cO(6d$XS.-rVw};!{",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "dJTP,c{]U~^I5wc{47MB",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "XZfH)q2V$cvQ#l-@p-J%",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "0J4MF(dtg-6cUmAeK`M1",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "lw[w`(xBzbnV8/%WC=,$",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "~RD/AN=Wa[pg8(g-{9qQ",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "Q`c[Z_vK*Jo[StI[4GMI",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "qx_q}{^|I$x%28+2GGo5",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "CS$t?(hVr;h!M%*B|hzH",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": ".JRNA!NN@}3#lizpvF~T",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "#T*YB#V)}NPL,v6YdGZ9",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "1E=^j=Q$UFmW,xZf9+mC",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "]nVR+}@mH.Ov@RZ}`~-Z",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "Q^tu=6Y0C)Mc?;(a3o#!",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "#VzhEf5O8V/5+RZS3@Je",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "xk8vEtS]%)CZ/QuaT/Lj",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "Opi.RuFg$6wN^yDAh0n^",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": ",41xtK7!G,(lGEe~rNK.",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "`qX~eVUTuD9Wr{6{1.HT",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "?K$mQ`buFDSvNH{6,|YI",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "$E.(*6=OQT#,G,S,tA#%",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "%v{B-EH/0=NO+345pyeh",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "`}XWo2S0;-kzIBDcGSdt",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "6Uj@diR(Q]_VTp3WsoX/",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "NpBw1}#n_fFxkb|)ixcV",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "!jBz%;QHI`rHpKsfK]Mq",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "|lHldh^Z-8v*]a={*Mo^",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "l}HP,|%N[5NZq6T8lUT[",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "]vFoNK+UQ#qydD7oKf!y",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "?Vsl}U:d,iw}$lv`c(^j",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "7l5fA3u=SK$*J).ncXRi",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "m5E-kK0K/CZ@UrXx{[Lk",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "3Q:vk/KLd;^U)AUAyoU.",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "N_?uI],?CL_zN%=]IU~N",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "F-5wDM|-wV@6,x#|X}w!",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "|8=~HGg$=1ablQ{${.LL",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "V$}(E+R$R?IwRDW?9tt@",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "[!-n6i,=kv=TN3=@K4r@",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "#lVejcw[;|H@*HZ)zCbP",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "e}G=+.)O!bQ+9{7*fQD|",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "DV,@h)ix6,%-$mi5x]-U",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "X4US0b.(!:=cf78zl;{h",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "AO-yLS/pH:FU(uL1KV`O",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "mSSRLhwi/0MKH5;-L0e`",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "cca(4mNT9[gG]9mTs9]V",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "((iD;9)}5Hd{Z:52qf_m",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "69j/M]uSBwJViYYfif{G",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "]=wd9]AFV}ABC4{0}QWP",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "7e/A.pf,0~#AkN*L`Lfj",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "RNAIBgE~Tkz~oI}@(o(x",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "J4}nu89xA:[RmYEY!u|E",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "w.xY{lBVU9M8J@RXbKtd",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "9eO@ax|65^]pr[2sRC{}",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "?EOYw|G/_PAc)QjeA+cY",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "b.ub=|Uf4(?t{jX5o]y]",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}