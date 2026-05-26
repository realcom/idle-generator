{
  "blocks": {
    "blocks": [
      {
        "fields": {
          "TYPE": "board",
          "VAR": {
            "id": "qGXFs49SXVt2ZmBlWy5Z"
          }
        },
        "id": "UOxn)lbtT-c6O32?)n.g",
        "inputs": {
          "VALUE": {
            "block": {
              "fields": {
                "OP": "ADD"
              },
              "id": "f8Skaj,.^.wh{1@Fg+z_",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "MINUS"
                    },
                    "id": "Dl]+4Sz}^mn0}OVs?5;n",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "THIS": false,
                            "VAR": "boardVariable:Tick"
                          },
                          "id": "1:AHlqsnOId{8/pTMT^Y",
                          "type": "variables_get_reserved"
                        },
                        "shadow": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "ZE)VjMsdrdHI|IWb6hB,",
                          "type": "math_number"
                        }
                      },
                      "B": {
                        "block": {
                          "id": "*x1^~8)b2s!TeqqvtmxX",
                          "inputs": {
                            "DIVIDEND": {
                              "block": {
                                "fields": {
                                  "THIS": false,
                                  "VAR": "boardVariable:Tick"
                                },
                                "id": "Tc6qoqh)Nq_w79,Q]q-$",
                                "type": "variables_get_reserved"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 64
                                },
                                "id": "EbESwtz#./^X:ShdCyv+",
                                "type": "math_number"
                              }
                            },
                            "DIVISOR": {
                              "shadow": {
                                "fields": {
                                  "NUM": 15
                                },
                                "id": "W2L=xYyUwTll_4i??v]#",
                                "type": "math_number"
                              }
                            }
                          },
                          "type": "math_modulo"
                        },
                        "shadow": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "kFl?HT#1WQAg}IQ./0W!",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "math_arithmetic"
                  },
                  "shadow": {
                    "fields": {
                      "NUM": 1
                    },
                    "id": "Qa*wm),GftL1a?`]1k=k",
                    "type": "math_number"
                  }
                },
                "B": {
                  "shadow": {
                    "fields": {
                      "NUM": 15
                    },
                    "id": "sLl#$lio/1,Re6dM-PG/",
                    "type": "math_number"
                  }
                }
              },
              "type": "math_arithmetic"
            }
          }
        },
        "type": "variables_set",
        "x": -345,
        "y": -525
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_WaveEnd_Start",
    "period": "0",
    "triggerType": "0"
  },
  "scroll": {},
  "variables": [
    {
      "id": "~d*MxHNEiu`x6tZt?s6=",
      "name": "Gem shops"
    },
    {
      "id": "$cyuTsBXJQsW?hK;8CCj",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "^GOd]tuzzt@Y1VN:{WzI",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "[RQ898@y(Y`.:t+b!K8V",
      "name": "Unit/Time01"
    },
    {
      "id": "qAl+J`p0nko:/piA{U]}",
      "name": "Unit/Time02"
    },
    {
      "id": "mmyP?nF#^~ZRp5Y+TIq4",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "b]^k^0KPv;tgY=KxPh[*",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "bIV;@Txi;2HKVvwTWE^p",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "J*~BWGBHyB}7ii9AtI-l",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "DVri#Qz7*b=^A+cwe]d-",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "p22PiQpDV$/x;-pr-w})",
      "name": "Unit/Tick"
    },
    {
      "id": "11Z2(JqB]O:$G4%M.[^l",
      "name": "Unit/Rome"
    },
    {
      "id": "p^CQj]GQaXbXx/HQf=B4",
      "name": "@Unit/Delay"
    },
    {
      "id": "!l;?Nl#`q})se^dR%/_C",
      "name": "@Unit/Range01"
    },
    {
      "id": "G:Eufml{7rEu~T;CNmx[",
      "name": "@Unit/Range02"
    },
    {
      "id": "TB6B@EL21Rlp2m7I0C`v",
      "name": "@Unit/Range03"
    },
    {
      "id": "wmw#)re7bK7X6~:Ud.=i",
      "name": "@Unit/Range04"
    },
    {
      "id": "ldY;?{-0:+%(OMRnv.w,",
      "name": "@Unit/Range05"
    },
    {
      "id": "yvzX_nzseI%aT9FNL)@2",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "Gj:rU]YQk4cQvpnb;~0X",
      "name": "@Unit/Variable01"
    },
    {
      "id": "(k5Y!?YU|Wy7Y8Jh|0;t",
      "name": "@Unit/Variable02"
    },
    {
      "id": "lgINkQ*WS}hB8]:CQ_]F",
      "name": "@Unit/Variable03"
    },
    {
      "id": "}yag20(-/0{MZsjL~#+]",
      "name": "@Unit/Variable04"
    },
    {
      "id": "q@.)Ddu`@I0=1e?KJy?e",
      "name": "@Unit/Variable05"
    },
    {
      "id": "{]Db7Bj2MgN%nnFVR:2+",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "M_b;FFOd@!fKHd9Ug1gq",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "Va}2aUw5az?@5QCcjyp9",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "0fpPLZa10zShWZC9q3`@",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "Y]$Hw#ZW,W+T)rKdW?,9",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "!sW2b,_}R3(p-]KK#,gW",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "gnT`w:Vb*U3s0SAs=J7%",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "uCGUXDskUX=0-M*$%UVD",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "{hQocZQ}G;Zy$a,wdAXF",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "!QX)3bcdo]^l_4XkkGS,",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "3p%PqZI3Rf+aZd0lU[}@",
      "name": "@Map/Variable01"
    },
    {
      "id": "Fcd.C4nNDyWqc{51?yqL",
      "name": "@Map/Variable02"
    },
    {
      "id": "hghS`nBr5Xr]BBwSOApz",
      "name": "@Map/Variable03"
    },
    {
      "id": "HK.A1N3aG9J$1Da?Y1x^",
      "name": "@Map/Variable04"
    },
    {
      "id": "Jk;c=OM{5i0Vjgy4V8T)",
      "name": "@Map/Variable05"
    },
    {
      "id": "#XN7|8/M)y1|@73tbzq)",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "3$y$qcWcJ}k@`Lk${Br!",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "LY5eo1S`;O2d%#Bc=,lX",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "5swD+0^BmVoHam531iv[",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "PPy(FABEXvjW)*~4;`M5",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "CY0P/xdC$u[39k)h,wC-",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "M5GwEr]0N8qIh*cg%,Zy",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "@tm(!FP}3jK]-G9_DH;Y",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "!:pS[EFJbrUEIpA,+[Y0",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "7]+R82sCV{lD{{Pwn@n#",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "/$$p{.*;KaXwzmNrFJ5J",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "lTq-hyndG=JO@Oy!*{h^",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "#=9s6C^ru4AavvIYRfkH",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "r/,o28Gp~r49~mxaddLr",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "nl@@/GyI[{6XEgBIqIeg",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "(e-BR,X0gAVj0T4e)I8O",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "VVr*a?ec*1C,qsIv+5Rw",
      "name": "Map/Wave"
    },
    {
      "id": "r/IP~A[s.nY+(vI*E=fe",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "bgH[IsXK08IUr{+o+S#V",
      "name": "Map/IsClear"
    },
    {
      "id": "wE6*#FW$tNBl7W;($[RM",
      "name": "Map/Wave/Step"
    },
    {
      "id": ")srR3[-o/P-0/?B^b]jq",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "2oI=a%%y@/ln+R,l:(Re",
      "name": "Map/IsSpawn"
    },
    {
      "id": "-BU_LVcf5^#xrdi;ucTF",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "qGXFs49SXVt2ZmBlWy5Z",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "mlrnK.9I]:P?$^K7;wC^",
      "name": "Map/Wave/State"
    },
    {
      "id": "3Pb(~M6b%Nw6hR{2-wQ.",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "sBy6#sfg+_3#yY)$a[j3",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "[lm2mN$$lxHEid?3={HC",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "E_{8VDI^ZA/42q%aoNu*",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "oEnee|7c[P[;Gli{TnG9",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "{*(~Q=C/Bm9?3E;eR%Mr",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "L*yo9Nt2JlDV0aX36v.h",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "4*WY8{9ws$tCba8tz[k:",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "@6T/GY*UQS`W2{/(c4}B",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "vzD!G!BsDYB?^0janF~P",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "C9M*rg^V)!Bmspc6g%an",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "Hq0w(Jqi/CT-Boeo/|h3",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": ";fc8c@4Blp4_Q2?lUk9s",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "NqM#jb%Y5C~+8[g,lqDS",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "6I]@QE*Z`bS#Ey1{4dbp",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "ryH|vQgI2E(.tzMCy]81",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": ".K/q33S=|HR[?}RL(3gR",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "?YVV%wXSf%Zm}w-Ccxk2",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "`P0rmRq|ZyrS@nr|l)g#",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "ZBA}66B1uPZW,n8;cJ;9",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "`$QV]WZY1W,/y+4Y9ipf",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "Ap;-}!dn2BQl)*2k/QDh",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "G,G8Ae{yR9v_gq{h?()l",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "Ac1/KAJr6waI3DGV},]w",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "PZf:7:Yb`q.YtWk=ssj5",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "]o0:7Hl*q4iNg@s=S(N4",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "AkL02{hO7N.V~D[`;J+k",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "c/]AjXywJNG#8|~7xg96",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": ";EgrZ#Ma)%]8V_usU3i_",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "eP*YSV,u~5y,Pp,aT+N(",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "o8TP*t!ssIr;M]Pa_~.V",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "NT/qU$0j4VC=q9tc[vfK",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "oxLQ(ckI4J?d0wi,+YYM",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "TGu__%*TgK?KI5[zLy~y",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": ")=p#/d@.F(.jLq.SjkaZ",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "pPjUn$(TFB6#HSZdv2X@",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "2U2,c2FoS8x5#/a*9uBK",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "oxweT(7QGVT+AfMTCN)T",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "-Q,#$;gI8K]s^`3Zkt-x",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "0*?in|8oN,30i##9b[n0",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "Rh{6Jbz@=$p-7g:Fuu+v",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "h!vhUaZ$XZCq5rDHM*pm",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "~YNyVImSi6/JmSw^D1q]",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "-clif)jtI6%;YC[ndcZ`",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "SbX{=G~}|22^(,5E*{dg",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "I$1vIz{y#`rA)hF{rSR)",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "M_f%t*-Du|;.y[)tRuTC",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "^.d)o85sO}Byxq!o+yLZ",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "-}Q.+]Zx]+,dK$nA))@I",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "_/nH-X,YW0?acK5)Z**E",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "z9~l*=XP!Nh/7Q~ywTBh",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "8|N86Ub:;_gnsqr|}Mc`",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "{d!=n}ED4lgRU+S-]Ve(",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "RYQ$_BA|Oz]V*%b~l|*m",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "Hpnkl%!a:z+B?C+E,I)K",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "K95=qk?h)DqXRw*:_-4,",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "FL,{wJR{oJAgR/Zb4@:?",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "t:-;cHSn#-:TrMBeV_Iv",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "X3-V+!.wZq$r4cXb*z[5",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "FOp?QG5nE7rN)JAK#7/:",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": ";Lzt?@R]0FwS+`59P123",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "[K;+:XK5?|%[2]+:9a(]",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "F},^Vkf;3QA18yZ?#j/N",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "dUj|Vt-dDTkpR8h4#F6k",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "Ps.E5A8n[7.G:rso^znG",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "LCYp[=n/=SS)Ez)Mp+49",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "{u)Wn]*@]Bbjv}_Xz2h:",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "U7+TvGAo_a1gn{HijODj",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "):-{;Vz{8?qdRyq#P1rc",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "`V}qyj`lpdbWJtwI},(T",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "6:c5O`cE(L!AuCS[u##1",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "N*LRnHFc(]]u,qqzn,?T",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": ",[G{hDc{xKO@V0|QiV9}",
      "name": "@Map/Wave5/Monster10"
    }
  ]
}