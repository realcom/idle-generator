{
  "blocks": {
    "blocks": [
      {
        "id": "0I]eR0#htis)|**X+%96",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "TYPE": "caller",
                "VAR": {
                  "id": "LLx(.h_J_d3HBM;~8#E9"
                }
              },
              "id": "mk2--!1^9zCM,j7A|H_e",
              "inputs": {
                "DELTA": {
                  "shadow": {
                    "fields": {
                      "NUM": 1
                    },
                    "id": "wh71,d.$D_HV|GRCRs5c",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "TYPE": "caller",
                    "VAR": {
                      "id": "?;mfZHdkW9Z0uZ{@SvTp"
                    }
                  },
                  "id": "-+xqV4j;`m62!Ihnl0iO",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "THIS": true,
                          "VAR": "unitVariable:CumulativeLuckAppliedCount"
                        },
                        "id": "H:dk(hOk`zRdjP|ZJHjV",
                        "type": "variables_get_reserved"
                      }
                    }
                  },
                  "type": "variables_set"
                }
              },
              "type": "math_change"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "EQ"
              },
              "id": "1a*u,,AE=a`J%@wmmA3T",
              "inputs": {
                "A": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "LLx(.h_J_d3HBM;~8#E9"
                      }
                    },
                    "id": "*u[wLjc9c=,g^+8kpHK`",
                    "type": "variables_get"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "O}y]KY(fS27cs.m-UdTT",
                    "type": "math_number"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": -945,
        "y": -965
      },
      {
        "id": "7xdm}vCVtoTsIZ;]3W1s",
        "inputs": {
          "DO0": {
            "block": {
              "id": "M7k7^+ZaD9Xq!]eQAE0!",
              "inputs": {
                "DO": {
                  "block": {
                    "extraState": "<mutation itemCount=\"5\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;DirectionX (default = unit X)&quot;,&quot;name&quot;:&quot;DirectionX&quot;},{&quot;comment&quot;:&quot;DirectionY (default = unit Y)&quot;,&quot;name&quot;:&quot;DirectionY&quot;}]\"></mutation>",
                    "fields": {
                      "NAME": "unitMethod:UseSkill",
                      "THIS": true
                    },
                    "id": "JxRI,bFxX*Kd,}-AU_kb",
                    "inputs": {
                      "ARG0": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "caller",
                            "VAR": {
                              "id": "hk)*#n_ACI5%(QT:Oq?`"
                            }
                          },
                          "id": ":SQ[ni{V*H{z6JL?)KWM",
                          "type": "variables_get"
                        }
                      }
                    },
                    "type": "function_call"
                  }
                },
                "TIMES": {
                  "block": {
                    "fields": {
                      "OP": "MINUS"
                    },
                    "id": "h2KmTvV=gT~Y-z^r-7gN",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "THIS": true,
                            "VAR": "unitVariable:CumulativeLuckAppliedCount"
                          },
                          "id": ";#{3~W%O=,:38mB8oOkG",
                          "type": "variables_get_reserved"
                        },
                        "shadow": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "#V3Gtkz*knAzMTl3KZya",
                          "type": "math_number"
                        }
                      },
                      "B": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "caller",
                            "VAR": {
                              "id": "?;mfZHdkW9Z0uZ{@SvTp"
                            }
                          },
                          "id": "=_ONSK(!J_p|!64Gw;h)",
                          "type": "variables_get"
                        },
                        "shadow": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "YUGq@jlI6!+/iCo4+$h?",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "math_arithmetic"
                  },
                  "shadow": {
                    "fields": {
                      "NUM": 10
                    },
                    "id": "5ZK__7MG[V*c5zL/54!{",
                    "type": "math_number"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "TYPE": "caller",
                    "VAR": {
                      "id": "?;mfZHdkW9Z0uZ{@SvTp"
                    }
                  },
                  "id": "ctKz}Oz,[[1g!64~L/8B",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "THIS": true,
                          "VAR": "unitVariable:CumulativeLuckAppliedCount"
                        },
                        "id": "o/Bv~5#Oku6qPwAix0xQ",
                        "type": "variables_get_reserved"
                      }
                    }
                  },
                  "type": "variables_set"
                }
              },
              "type": "controls_repeat_ext"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "GT"
              },
              "id": "s:~nZ3Wi!_T]vq6T,|l^",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "unitVariable:CumulativeLuckAppliedCount"
                    },
                    "id": "4p9^({lnVe6t{7rAxHv;",
                    "type": "variables_get_reserved"
                  }
                },
                "B": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "?;mfZHdkW9Z0uZ{@SvTp"
                      }
                    },
                    "id": "EonPd8fAcws05:xh9nF{",
                    "type": "variables_get"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": -955,
        "y": -679
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Buff_ShootingStarOnLuckTrigger_Update",
    "period": "15",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": "xzsVrJBSxf=2,esS0ZH=",
      "name": "Gem"
    },
    {
      "id": "%9`[lo(B|trujdW{,DXW",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "1qOjpj,r6FQ=KwqYSDAC",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "RjjUaUE0{Zz$dP=C,uue",
      "name": "Unit/Time01"
    },
    {
      "id": "TL5};sH^U:,05v0$#J!#",
      "name": "Unit/Time02"
    },
    {
      "id": "90i.W3Nz?lvqJ{*~YGK.",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "@:bA{o*_W-r{OmY))g5R",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "E,cxv_pj?/6{v1a.|V[~",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "G:v~68#4wgiR_Pm.$bH/",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "r,C/#A*:pkk)eM|@G`L]",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "+^P*`KSju){fn^@UHhgb",
      "name": "Unit/Tick"
    },
    {
      "id": "vL?,B=HeN4;^xSOrZu:(",
      "name": "Unit/Rome"
    },
    {
      "id": "8S)hC~G}A:n]sxf4hm2/",
      "name": "@Unit/Delay"
    },
    {
      "id": "QRzWqM|Dq+kGlvcMxr?n",
      "name": "@Unit/Range01"
    },
    {
      "id": "%~lD7WrZJNC$]uFnEh+Q",
      "name": "@Unit/Range02"
    },
    {
      "id": "|ygbqS(c[BoXSfO6fp^`",
      "name": "@Unit/Range03"
    },
    {
      "id": "GpR%U?mC.(s#HgRK_Jxp",
      "name": "@Unit/Range04"
    },
    {
      "id": "zp+HEu;Nv,{mXbMz0H`5",
      "name": "@Unit/Range05"
    },
    {
      "id": "`eA)^)(.Ur-JN=#Y,^q5",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "b;;dCWPRUSY_[8iL_4S#",
      "name": "@Unit/Variable01"
    },
    {
      "id": "@RH!3J4.|N$*~n5-;+x.",
      "name": "@Unit/Variable02"
    },
    {
      "id": "o_zb1P|(as_0CDz#ulU|",
      "name": "@Unit/Variable03"
    },
    {
      "id": "Qtgm3z=KK)}n[t(!dm*,",
      "name": "@Unit/Variable04"
    },
    {
      "id": "?!2dkg4+Z}#rFkzJhSpU",
      "name": "@Unit/Variable05"
    },
    {
      "id": "4tsEZ|{MZQTLnYK/:5S[",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "$JfI[{gN2IbYE+3G*?.i",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "].)1L0qtpq5hqnOc(00%",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "]-4KXR[#R9wr-Oksx6tC",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "Bk.k)j`61kI2aR@1F#=@",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "Y8/(G2v.E{_D`xUD=^$v",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "Kjzg9t+PyF0%Q3~zAF2Y",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "_Md5?BN3IKbUMksEmcFI",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "KMpKj%^2(p?v_[}4es0=",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "W67bZ-?5RcOev;ff,`N!",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "Ncb.7[--p:+Q~b1bI81!",
      "name": "@Map/Variable01"
    },
    {
      "id": "Mzg.70T;mZZ,csVnB4Om",
      "name": "@Map/Variable02"
    },
    {
      "id": "%%Nj|s;prM0+HO9Gp%8O",
      "name": "@Map/Variable03"
    },
    {
      "id": "1{{Y+Ut@tT!oVC9Y0a.y",
      "name": "@Map/Variable04"
    },
    {
      "id": "a4n5En7QXMZJZIY;h.Ng",
      "name": "@Map/Variable05"
    },
    {
      "id": "W(zRH4]K{YYrwi}@72G#",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "bSn7VemU`XHUpf]V4:vC",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "=4bqOjpzNys5=Kv.Sk`,",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "mvNZ@e#czimQtw6d]#|L",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "heY%{m-%;~8pmno#pR)H",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "A^c8L;#N6/MUU%BDmu`f",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "^LbfJ3|h{3#cE^@NS]I,",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "e]q7U~,H,4L1[VlLVpH:",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "U~gL)JeNA]$^Ri%@i6eM",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "cDHV=vkXT=qG$zjgDc/p",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "@=z3l8tF;[2`eur1g$7K",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "Pirnv!w=LEUc!NjPnABd",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "=.Dhq;^9tqvNHYTOehI(",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "q5,y4LE7[W~FA_BC-uM*",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "]+_qZ!OKihUK++ls_[Wv",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "[^L3AP[k6}j;6J$71):m",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "+-O-|k{l{5fv]VNZubKr",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "x9{dy56ao4j7~,Fdbj[f",
      "name": "Map/Wave"
    },
    {
      "id": "*~zzI^Mb8d[m.Nk_cVd,",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "$GM$z%RzudrEI-plVs@j",
      "name": "Map/IsClear"
    },
    {
      "id": "*|/,[FZ,KUpVx7golZDA",
      "name": "Map/Wave/Step"
    },
    {
      "id": "|j3ZG[+gC:hn@YF~3EkM",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "GRoo6GS|bA?a}zvF(JF!",
      "name": "Map/IsSpawn"
    },
    {
      "id": "o/1:?@h//KD[^t.0-mgU",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "!RUZz^tPrlFO:PQ6bsS!",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "FT~W.Msp~Uj~k{3]?Bd[",
      "name": "Map/Wave/State"
    },
    {
      "id": "Y3gGF-~?f8?ENJWL8)(T",
      "name": "Map/Player/Moving"
    },
    {
      "id": "hk)*#n_ACI5%(QT:Oq?`",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "A(8GDS@S:Ml(_C^l$f%Z",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "nVlvh8v7^t:j_oC(#O.j",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "AcJzX==:O4EOfjt3u2+k",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "U3]PN_sO~0wAGj%SR.Mu",
      "name": "@Buff/Variable/05"
    },
    {
      "id": ";Xg4gY+Ce`fx7?{oSDXj",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "bS}LjLZ1K!_uZj;kn=0/",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "(kscjhoSXKbe?J3)Y`5q",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "X+^76[2a26cSG`Ww/=oL",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "?;mfZHdkW9Z0uZ{@SvTp",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "1QBi.,#T=v8vJuL@(2`2",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "6LY=,3`u~X0X]ROvigDM",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "sy@E7V]N/v$QkW`XJn(X",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "+ta)o3(=[glzS-$l0,Zh",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "YjAIO!DUhh+d*0:wlr;t",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "12#[%{5)o~OW/GXI@RrV",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "seqTmk5o#*q!d3k|6AJ0",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": ";:#ZDP_tn~!WR#_U7gZ3",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "2G{8qg/;[$XAB-occ~o^",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "fui[P~VGI}QgS4j*#Y|V",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "hWj}on}Xn0ipJf7kShu0",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "3W=DFVuzr4bzb:%FVUWF",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "H#V,!Njtv!wm3b,EWoqy",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "P@P_`/?a%(^U^;GC`EE,",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "IGmA(cz7I=hI%7jg:KkX",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "bUI%oR0_S6W6mU7}f+!d",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "blMdrl3lc39,ri93Fo9*",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "t|SEcxR!0)t0*G/k!iIs",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": ".?,gC8M+p0nD`g^Z[`*T",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "K*MBt$HIJ=6wjaXK$ep{",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "dN_y?U#:`I#)f`A0_-U0",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": ":PV0fg8_1]Bz:%^F|z[B",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": ".s]f03_5_Zd{*Xg7wFvB",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "JCxVuM;L[%:k;zFXF$$:",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "-1B1SA0wmu@P$MAEXv87",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "rjbVC}.X/c)UG)R^.E1{",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": ";$G7-Iq|9c.E1nsP4+U=",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "LO3FZ3M-Qo^58o3va$*l",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "iRzEz}Lrxi)01jYbZe;+",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "e*Hqx^SN9h6r0UvFP|xW",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "tG#`-lZA$v}bI|}@|g@}",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "y-^l^:w-|Bm7Nc+8X0gU",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "-3@3ACyF(gz-U%(p0oQd",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "%AF-q[5wHaf8u;n(79tk",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "|1z~88]GZH)}rJg;Hp$]",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "Ab+}I}CClWK(@uF46[-.",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "/h-Dkia;*OyphbOpCs,;",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "eL;bc%,6C[z.Bi?PNak6",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "y_H_$mOC{B%F6|*/)(SK",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "Fz8!S4vMdd;IhY?e*WY5",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "/HP(e/z$e;W5%kFer5F0",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "Ms!3iygw3*HKzBg0}nLi",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "3/(HnS{V3U)=x]E^z?vA",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "bBS7=_=e0j0_XVPvp#CW",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "qeLd/-#8A!#A8V41RWbS",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "Fx]BKmj!L)slq4EjE!`[",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "r#@tvf_8lZ6Y`/~9Sm%j",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "YaATRAOs0H0whiZ4o%=?",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "e)su*fBOQ#0x-KKZq1Wp",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "yq7;wk5.~i`Lu^Elp_/k",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "8bFL-K4@MV``ZrC.NEN0",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "_FY;cGRCuX2HIgv6c}E}",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "[-:{#}WrH-B~%cE.hD[L",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "9Mc,H?L%S8(i4xAZJKB%",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "InuK]FC2yU6xk-j1qy(I",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "n%UEd9ZPTV5D=Ps,06lH",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "uF0l.pr^V!s,oS:cRB77",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "h9,~0w6XAPtpnIyGWh+[",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "X|QTi=sQlZ*cV:xKFZBA",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "kb-j{NhJ$32fN/+WMMyn",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "Ll$k[=@?(TD^T.AP:%ge",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "^a?1=xnI$o@$JZFvj|T*",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "vjDoLAwN,9]Pf$7gJ)#2",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "-Kq0-W2Q4^ndfVz8.C1b",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "/YL{%#6;_Ao@r`HkZ1X=",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "s@VkS6Cn+v=]xEXlWf`2",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "EN`UQXcP(LXYl=)M^!E(",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "QJ2ucr3lGKcPJX#!e$a;",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "H9*{q#n1e?=ZCAHd1X,J",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "]?ML3tk4%Y0x}.(.M72N",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "0]k2@nK--cGXHM.fxMxo",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "Nw(*{-P;xAX:0uxXn(?j",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "x6t}|W`gAxQo8-f=o`(v",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "_%WUV+LAVM3@J;yFJ{Zt",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "LLx(.h_J_d3HBM;~8#E9",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "Mh)eMG}=pQIfNX,t,-37",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "+S4WvqbXm{D,Bf7e!=x1",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "(?}6:UEmB{bBl$2VU/X/",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "DN^;gZ@Q|)if2En[AZka",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "xyaKYy31PiiAD[bjg!^F",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "HKsWP~?$tnu6{4C.ZY!y",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "O~wnp]uGoBqfXY?|7AFV",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "qk=kp%`bdq%.E`i3aYWJ",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "5LALWK;DW7b9[-6^by4[",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "pzv*05Y@0y]EU@~9NXB5",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "Cr!lcyip%-QbXe95?{b3",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "Z0V-w,Uth_C:]5qk=!{t",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "if=,u?d;Q?#n0^Qo!GO~",
      "name": "@Map/Progress"
    },
    {
      "id": "}O,D,S?yK),0vkeU0Xd{",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "zXqe]5q|pFwhJ^(dbjwH",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "D_H^=4cbHi8ppjw;.FN:",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "@Rfu4iXea*y#-wPjjvdy",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "C6n!rSZ3dwy;70CVdL5r",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "a*#?_8X2eJXVBFDKkzCK",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "mh?$#E5_=9[NL{ek45o~",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "D)jXo9ojr~k,taTX`Y@D",
      "name": "Map/DisplayWinningTeam"
    }
  ]
}