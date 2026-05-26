{
  "blocks": {
    "blocks": [
      {
        "fields": {
          "NAME": ""
        },
        "id": "s,}lM!.QGFyXBtkB:kDe",
        "inputs": {
          "TEXT": {
            "block": {
              "fields": {
                "TEXT": "wave end encounter Trait!"
              },
              "id": "c_@R~epqq*n#vY*K)_B^",
              "type": "text"
            }
          }
        },
        "next": {
          "block": {
            "fields": {
              "TYPE": "board",
              "VAR": {
                "id": "5va;w9a#rOXVLTyE46ic"
              }
            },
            "id": "K?G7;$!t;K%yEq]NX=W]",
            "inputs": {
              "VALUE": {
                "block": {
                  "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;현재 wave단계 입력&quot;,&quot;name&quot;:&quot;Level&quot;}]\"></mutation>",
                  "fields": {
                    "NAME": "boardMethod:StartWaveEndSelectTrait",
                    "THIS": false
                  },
                  "id": "FYk?+j.`[PrI[?8fan[G",
                  "inputs": {
                    "ARG0": {
                      "block": {
                        "extraState": "<mutation></mutation>",
                        "fields": {
                          "TYPE": "board",
                          "VAR": {
                            "id": "eYsi)e[]WNE;}h#NIkav"
                          }
                        },
                        "id": "ve+r/9WZLLacw@+ON$zW",
                        "type": "variables_get"
                      }
                    }
                  },
                  "type": "function_call_return"
                }
              }
            },
            "next": {
              "block": {
                "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                "fields": {
                  "NAME": "boardMethod:ShowPopup",
                  "THIS": false
                },
                "id": "#41oCmL!~Gn5iO`B4,^)",
                "inputs": {
                  "TEXT": {
                    "block": {
                      "fields": {
                        "TEXT": "Popup_Encounter"
                      },
                      "id": "ar_(7nLSp2;:R|WUHkL8",
                      "type": "text"
                    }
                  },
                  "VAR1": {
                    "block": {
                      "extraState": "<mutation></mutation>",
                      "fields": {
                        "TYPE": "board",
                        "VAR": {
                          "id": "5va;w9a#rOXVLTyE46ic"
                        }
                      },
                      "id": "hL;cVS]d=WBM$=@_`D+M",
                      "type": "variables_get"
                    }
                  }
                },
                "next": {
                  "block": {
                    "extraState": "<mutation itemCount=\"8\" metadata=\"[{&quot;comment&quot;:&quot;Unit Data Id (필수)&quot;,&quot;name&quot;:&quot;UnitDataId&quot;},{&quot;comment&quot;:&quot;Location Id&quot;,&quot;name&quot;:&quot;LocationId&quot;},{&quot;comment&quot;:&quot;Position X&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;Angle, in radians (default = random)&quot;,&quot;name&quot;:&quot;Angle&quot;},{&quot;comment&quot;:&quot;Team (default = Neutral)&quot;,&quot;name&quot;:&quot;Team&quot;},{&quot;comment&quot;:&quot;Count (default = 1)&quot;,&quot;name&quot;:&quot;Count&quot;},{&quot;comment&quot;:&quot;Offset&quot;,&quot;name&quot;:&quot;Offset&quot;}]\"></mutation>",
                    "fields": {
                      "NAME": "boardMethod:AddUnit",
                      "THIS": false
                    },
                    "id": "!t4$s%w-4X;,*,!hSi?K",
                    "inputs": {
                      "ARG0": {
                        "block": {
                          "extraState": "<mutation></mutation>",
                          "fields": {
                            "TYPE": "board",
                            "VAR": {
                              "id": "5va;w9a#rOXVLTyE46ic"
                            }
                          },
                          "id": "0DH37,bET!{4To~:+Lwi",
                          "type": "variables_get"
                        }
                      },
                      "ARG2": {
                        "block": {
                          "fields": {
                            "OP": "ADD"
                          },
                          "id": "k#Pj)$b!`TLGg:2f/$]C",
                          "inputs": {
                            "A": {
                              "block": {
                                "extraState": "<mutation></mutation>",
                                "fields": {
                                  "TYPE": "board",
                                  "VAR": {
                                    "id": "JIo5Aoae.Iypc#kC~Y|l"
                                  }
                                },
                                "id": "$RD:ZeOknXo]MerOg(8r",
                                "type": "variables_get"
                              },
                              "shadow": {
                                "fields": {
                                  "NUM": 1
                                },
                                "id": "^neTc/Km(]tY@3Byq{$,",
                                "type": "math_number"
                              }
                            },
                            "B": {
                              "shadow": {
                                "fields": {
                                  "NUM": 9
                                },
                                "id": "_!(;Q9IkFm9%$,RT_Js$",
                                "type": "math_number"
                              }
                            }
                          },
                          "type": "math_arithmetic"
                        }
                      },
                      "ARG3": {
                        "block": {
                          "fields": {
                            "NUM": 0
                          },
                          "id": "/WN~dFT%d8)kCM_)HWHA",
                          "type": "math_number"
                        }
                      },
                      "ARG5": {
                        "block": {
                          "fields": {
                            "VAR": "Neutral"
                          },
                          "id": "98-vlc_Q=drE8+2]Li*E",
                          "type": "teamtag_get"
                        }
                      }
                    },
                    "type": "function_call"
                  }
                },
                "type": "function_call_with_arguments"
              }
            },
            "type": "variables_set"
          }
        },
        "type": "debug",
        "x": 865,
        "y": 385
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Map_EncounterTraitWaveEnd",
    "period": "0",
    "triggerType": "0"
  },
  "scroll": {},
  "variables": [
    {
      "id": "D_+[LJo+U+lqcf^Dw._)",
      "name": "Map/IsInitVariables"
    },
    {
      "id": ".?5SRZo]IJVKOW}Pk)82",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "@9HHQ`*!{WDe9B[D4A?]",
      "name": "Unit/Time01"
    },
    {
      "id": "tb@n@]8J34PU-M?dpdMS",
      "name": "Unit/Time02"
    },
    {
      "id": "00kGg=(glTR]k2w1Wt%Q",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "z1-3tTWWk(o%;-DGY}qH",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "Cpux}~=Y${yHI`6JR@C4",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "K+*,*[|9?]b#Ws]uF3=d",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "JIo5Aoae.Iypc#kC~Y|l",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "b$6)XJ@{|pqdg$4gN-tu",
      "name": "Unit/Tick"
    },
    {
      "id": "atF$1a,z%Z_As[iQ~PlA",
      "name": "Unit/Rome"
    },
    {
      "id": "AQ}0}?n54Q$WNpo1Md09",
      "name": "@Unit/Delay"
    },
    {
      "id": "rykeG,dX9[eX7X;#h).T",
      "name": "@Unit/Range01"
    },
    {
      "id": "jOz#s-nNd];=BbF]*%Fe",
      "name": "@Unit/Range02"
    },
    {
      "id": "=nK)[.N8fw^3~OOpkk~#",
      "name": "@Unit/Range03"
    },
    {
      "id": "/hkxQ}|*aBxZS-|w(,!5",
      "name": "@Unit/Range04"
    },
    {
      "id": "xV`3`;/AV^mRxeU`:o1/",
      "name": "@Unit/Range05"
    },
    {
      "id": "[#)-zO}ei;n[9WP424;{",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": ";dDYG`[DIjMJz|8DiLJs",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "1k45xHitnm/]}h;lCc31",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "Z-@KYDvB^GU,gNkhOVo0",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "hZ_B*E{ROQo3+FlqH$@z",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": ";pI27Q2cp|yoF*J,+j]+",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "0wj%!z;?J#$l!mm5ef!J",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "15IAs=tzha-EysUn6t*N",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "i:1_:_cz#p1I^-zWNQ=%",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "CV{t.Wdq{q}c69Zlb~-x",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "ovkeVXtz~FQi|Gf?7/OR",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "de]KPF3{P~kVp9Y,GF)j",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "]7/$/mwGK7px07yNop82",
      "name": "@Map/Variable01"
    },
    {
      "id": "Ay~[9G:CqEW=8.nbMiOP",
      "name": "@Map/Variable02"
    },
    {
      "id": "W!|{#cqFPzcohM06w7s+",
      "name": "@Map/Variable03"
    },
    {
      "id": "BUhvauSrkfD/kVs_6#tt",
      "name": "@Map/Variable04"
    },
    {
      "id": "5va;w9a#rOXVLTyE46ic",
      "name": "@Map/Variable05"
    },
    {
      "id": "_?gT}Jr(S[00rjcli}}{",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "p+ca#vNG4bW*zlE6ZG)-",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "]T{HOJ(76$ww!C~%]%7Z",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "0j5;2Jpuf#]-sZB~8a8b",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "b0TOfc9Woc,V/-v9Z$ws",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "67|_[G+{ByY]DydsG3_o",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "Uk+`NB.jlF7+.)fmmw9l",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "qD9)x5w5+ho}XKxaJckP",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "F|hff=i+jJ|`%ws{XkEl",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": "`Tl+E^Qy8a;ICduQ/J%x",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": "mKL-{M[9s^n[8I!KkVg0",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "h9KAl38NQ(^0S3,qG.ZO",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "k2(+jyxJV(1l:qE91|Sv",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "QXO?tL{s8dm[B.T`zQT6",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "6Y:Zc#$H%lA;o{6#SY(b",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "]0VBaF-;nP:w3p{tP_4U",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "MGvT4_p{v=`Sas=,z*~Z",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "bQL-vy,`K/-+[2Y%t=~b",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "$u5[1v4ICURbL_gI~K%T",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "KK1oh!kH_n$Yr,70P7NV",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "K)]be*6yLR=@OPiJ~cCq",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "tb%eL);{EK%gO3Ihab4K",
      "name": "Map/BattleValue"
    },
    {
      "id": "(f1uRK{)]L$g=vPga[!B",
      "name": "Map/IsClear"
    },
    {
      "id": "`Z(@ax,Q$G4yHb(8Iq}@",
      "name": "Map/WaveCount"
    },
    {
      "id": ")$c9FT]x+[;S{.oCM(j%",
      "name": "Map/WaveTick"
    },
    {
      "id": "4[jBFc,kH8J(@v%=I.Sw",
      "name": "Map/IsSpawn"
    },
    {
      "id": "ec_B-iDf$4vUw(.H3cbt",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "n^HO8/1rBzFtl;fbz.P1",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "%g[PI`8#50rU8d3`-x]@",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "Bg3RexF+ZL#^`1B}1#8{",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "tH[Eq.LiXMdjt|lrZjLF",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "Btbc/_)5H)YY^/+00U=C",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "1g20Zu*AsYx+}yf=7:2:",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "ZSA+fZHI?U8PHiF3yG!#",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "f]V#cj+804K(`FeDlKm,",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "lcGXz+R~gag,!]r?I1}]",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "hT()|ByuTRoZFHsb-o*?",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "x9Dw;RJo7Ku:v)==!|x*",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "wA^tvMBg!~^KgPEdKWlV",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "DM~sKne}k9V1WkJ!cJG0",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "c[;4|8OFJ;nbS9?}]=gI",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "z/84!7Hq!C4I2N^8+2qj",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "d(~D=;w{+*2A*JY4z4Lv",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "baHV8,!,ue3!MH68f=NO",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "(s*kITnWNb00bwjLI#W3",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "b]l|{b*9TaLHFB,j,I(j",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "VHtajV;Eeck09t|.X(X`",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "j1|rK~z,;?n,/I)D~Vi1",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "?ptrD!M@/2TU#.rw(:F7",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "QR{8]/@_b/DvW.H(i;Kx",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "mgO-YN$Htb_GM%n+ykE=",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "8u/`-yOl[E/Ej$CuIHul",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "UeiI{PXs8McR7et:-U.g",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": ";q:fU4^7^Kd{3K_Eifus",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "vjp#x^!ybmI]?zgxZ/|7",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "^:_n/~?4jn(fS0}d,_Z{",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "}Vo*pYpHAO}#8HtA7gN#",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "Q_lvqF~fS`.Dpzc7-]]+",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "Yj^M*z^A:2dZx~mM$a;R",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "z%wsm1-0;y$Ik3!BjN2%",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": ";eOgWinfY;M/W^V2[1;N",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "aUmOaYlNl~uCm|]uqTAd",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "CQJzo{vFeIk:9]j4M=Pw",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "Shbl]@;ZPi+ZC[iP{Q|4",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "IEL~?*gc(uXL9w!va$;8",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "{~xq{fH{:g6YM)q{=J86",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "!lBG*bmSh5l8AMi?s4Bn",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "tx:sE^613:u]$HX^E,/F",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "_/E~Ons7nn,{Tb=lm/:F",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "iB@k,kp~tc=h)8ezDs[F",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "J7vlgae2^q-RWb:+%Qki",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": ";gJbF/|24$CllSpX??(~",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "PsO=?5E862Od=.Y?Z#cH",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "Z}L`gQ-F#m^f}q{YEWGW",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "QTTc)_!*4*,gcfC1tt0b",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "*d2lrjqCtV,,Q]xDP[:n",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "l1VUk0*pETEg%59Yvzz7",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "n{F1)XJS09+eT4v,p@C8",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "VAL$j5(RjT@qO@_w$t99",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "Vi$vDtW@`Am-9sGoVKBR",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "=4s~pM(6f$Pg5nt*ht/o",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "=Wh]@UfIu@?lhD#Vu4b9",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "jhpt4vh.!k6G~51SBOUe",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "oQXSD!LS#Hi6+R0a]I~E",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "h@c|hn~plVWa+V0nQXCG",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "_[uBIoe+V?vl1b58|jMY",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "sWUn#Zp^,JMoDjlVMY]p",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "@4=g_P!:-GLZFw#Sh](C",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "6Qs;!t?tzur:qAheMhTu",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "Cd8G^g%Va=3}ny%,un#e",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "!yc}A{SHP~aqw*R}QgdM",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "QpK*{soM14]3I$lizEi?",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "4Q[cpR,AX{TQ@+2x-T`n",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "v:6^mhOsz9EIUC;U3Qcb",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "^R{_W:M2YkR?NN$f~sv]",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "x1Qm6?K(Kkuqq)Cd/ame",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": ")_r9z!lH!{x]2n}i-,[j",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "}9!KdxbyW#P~1-qV*+{[",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "#~[JM4RT.?$1y5Kc]qQn",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "/3]DMpU6bw{(N$e7R%}P",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "^}2Z[rOsCH/nE(3LamgW",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "}YCs4a4W$3NwCF;oans@",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "=PzrvH::YPT4qV`xK8Pq",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "gA+0x8-}^{f`y!s7dHDZ",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "K~RaeG=%?!9|PpH#=h?A",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "n_iJdpZ94i|Rh%eC%U/f",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "#z||3#%!;kaNmpQe37DW",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "{*cj9uJ5Q+Hn0P72c~7U",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": ";5|xD?yjhTHrZ6W%},[s",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "F4Z1`i/eFzJl}.Zhv.Z;",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "lg`o.kWVa32{P@Z[,p_Z",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "%(!CtjjyRdD.QwuL,52f",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "Su)0`Sg6GSsN_/jw%AL[",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "%4pDX_nLMmZWLvGAKh3b",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "NNEeL]Rk5([vK(G=7~2j",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "H$,T6c]6zsb;=9epSqHf",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "P]?t1ysypG]4p{=o%u}Q",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "P,.[ENgv.4`)j}A({uEy",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "v3b+H^Xtq!3(+U+KB$yp",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "uLP4DelSXF6j3vz|kt$x",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "$c.BUmRn`6rYc@9nrT`%",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "-[#mem7`$V,ed^leyX2@",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "JVqec9lwILfmWsD*^%9i",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "GA-v`(9z(cQD5$@%^msE",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "5$lMkvh*+MG=a#jRsxkM",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "Pi+Gc^,tD|Ag:H`gPu]h",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "GAI=Apoc9Xj7A#6ba4,,",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "Pf#`d::fx[Q8WX0yN[DI",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "itcqoNJ+/%L^z|?90s@S",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "XYA3++Xg`u)jyk!}^bli",
      "name": "@Unit/Variable01"
    },
    {
      "id": "E$W9JVXpi$us4LOE9yf+",
      "name": "@Unit/Variable02"
    },
    {
      "id": "FiRZ5R4^rl9*w,f^G4)|",
      "name": "@Unit/Variable03"
    },
    {
      "id": "|v@:j[{v;BC=N}+vkdbl",
      "name": "@Unit/Variable04"
    },
    {
      "id": "Kw:[coSqd-eRmSssX/^N",
      "name": "@Unit/Variable05"
    },
    {
      "id": "w:7G^E$$GzUwfiY9sH8S",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "d%OYK(MU:A2}:La1H.7}",
      "name": "@Map/Encounter/Variable1"
    },
    {
      "id": "lfN4gkED|VuFu-2w2QxO",
      "name": "@Map/Encounter/Variable2"
    },
    {
      "id": "^arZp8,+$Cb{@Rtj4wTn",
      "name": "@Map/Encounter/Variable3"
    },
    {
      "id": "^^X`Y~ig:(ErOK2fk/wM",
      "name": "@Map/Encounter/Variable4"
    },
    {
      "id": ")=gO5qe^-uToLRl*Yq,=",
      "name": "@Map/Encounter/Variable5"
    },
    {
      "id": ",4}}TWcJ/qB~A`g@{`)f",
      "name": "@Skill/Trait/BlastIncreaseKBPercent"
    },
    {
      "id": "P3najikmDG{C7.a[]tcJ",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "nH_XxI_[X2_J4/|kDr-c",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "u-0@j3.eL}by|fN+I6)L",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "[:W;C;d0D8VUp9[n+OE+",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "1ZhfHTS97FVRjvk+$)(L",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "^iCzoDx9A+HHc#w4w2h-",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "jm9T9f}[pp)/^v})Hrqr",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "E.l]CVYpj9BPSs!!:scm",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "|n`jQ+zvvVZALsNoKi)U",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "G1?|ODq[NE#/m#,A-qhj",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": ",3B~bnWz5y~=30cpC!Ba",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "r+Yg[kqhOh.f+IP~9KH0",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "_H@uEtS)}7I7J#Z99g],",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "{9@t~2.#8i?PE+5l(XXT",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "73kQkdK/#9Y-6s-kEHsb",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "zwrU97V0p86q63$*Lq,r",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "]W[]E$)u0uUd@|lG.mJr",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "JdMV7K;lDTt4MWv)4*(4",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "ds+F{C3DZ%UO$me#aGF0",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "inu)WR,DpcIY7vLo(gJV",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "nHO-$fKVk:_9Q.4?EF$;",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "(6?%w6=dcgJXQrSw:/Wn",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "XIGT!@t;2$aAvf|LHr(P",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "r,CuQQdp,J0%X6Ub6iN/",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "lTGLcxVnxM8X6Bq`I@u)",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "r[P#=bf=60^U;NWL:CN!",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "(07*9`5%O#1edfoRY`$h",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "uP=~ACJ8XgQuNkh~PA}G",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "n*2p58%~Gh-WL:/S#O]b",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "pfJNx*;:Gb|2(P[tlF[8",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "73T)aQzXzJM$qG5@SR[/",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "@$fX/4GXy78CezW`CfVg",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "XAFT$]OfPH|mX?4B[p]~",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "Pq)oynC[d,f|[yxSGACD",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "Xv@af8rlt|5XEW04/*J)",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "w2kV,uK(P6=T#mpfNaf#",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "+;rO)Zg!O?@LndAt9rWE",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "ye:K=VVF#e~$?O/3roBp",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "YKgkr=n)+Ie/z`ZZ_H#3",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "3Rk})HK/1;_EV|^s41z-",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": ".hiX*)x;/0AB]TkJDTwa",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "5Swt7NYXxo=MAz,PIRNh",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "9`c_VsS`Y3MOm{@oE}_f",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "V6|^fZB2~b[E*)P%6Zku",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "o_{.Smnmrr~;uKnlf7*M",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "}($t.KS%{_(1ez6{Z[Uu",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "``2AxaPb58oRxb3+nX5h",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "lKzRxefO~Srxuy`gyN[Y",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "NZt%P[3tF=wVP_7+_u@!",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "nrE$oB43v$6K]3Z[_?yY",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "WmLTOGD0]mOCzHo$Ywe_",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "f(Q8cG@JkEI%#u-E_|kN",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "194`X/rW%7VIPkEIp^[t",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "sW+Xi-4[tF`dOqzQ=P?E",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "Tud0$h4?hD1fG+HnLVX[",
      "name": "보석 상점"
    },
    {
      "id": "eYsi)e[]WNE;}h#NIkav",
      "name": "Map/Wave"
    },
    {
      "id": "|95eqzv=%YQ=L%vMG:h!",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "Zoy!c6ndOjs|#(h6`k=6",
      "name": "Map/Wave/Step"
    },
    {
      "id": "81dEa4qna,A[J8Oyg]t5",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "y6/wlkjeH;VN]!aa_Uio",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "_z(Oubt].e!|G%.;L*0r",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "3}A2tM!T/F148#*(=u=-",
      "name": "Map/Wave/State"
    },
    {
      "id": "b:GcbH9SNJ|)MQ%~D]As",
      "name": "Gem shops"
    },
    {
      "id": "zPC/e{ufV`I,[!]`R}B|",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "9OVK4|odSS.!x8w_!DB$",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "l`P:Kn,7w^yZZyaJo8n-",
      "name": "Zem"
    },
    {
      "id": "pjM{aW/hd2,|VKz{a)iA",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "y?Qf1sL;HuyNS`/PS,)e",
      "name": "Gem"
    },
    {
      "id": "B($t3miAMQ7~x|W~Jz(`",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "W=6`lYg$XUSGdieJk1Az",
      "name": "Map/Player/Moving"
    },
    {
      "id": "/}gE|,mVbCIzY7Gaj6$1",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "BW^|0j{}T!DZAP_l]Mds",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "X-(^f-jPN,/7qzKYgS77",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "p]1rrW,pi+uG(+#)_s5l",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "rqP~7_V;*Bi_Loa@~6|N",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "/Lffp/v)BLTB}@u]znEy",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "!t;EJ2;?ipC~doS]X]Xf",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "A73Y)8W;:yZm=uhg1Jc^",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "uU4R/8rEEPQFRTmqgfr0",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "8`6NIMh,WezdY9BkoX~;",
      "name": "@Buff/Variable/08"
    },
    {
      "id": ";]O:f]MQ#7w]~bvG^fpH",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "/Va/pMQP8]k$wnaBYeEU",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "hJcGl)W|Tf@}5(6*`SV;",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "y.PI0*yg=8-`z?7IY1$T",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "R5Qh;fs=X:VnzKj,62t:",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "Px.VT:*=q]4nuV%f#9~k",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "2#.%J}{L;*Hz+Hq:]gym",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "{s9F](ISJd%.FjmeK5JB",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "=QgG=?-[:cgP6c}d|0TF",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "^iS4*USPeF}kpxW@r_23",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "|Ppzl*0,IONx~/7cuWJn",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "E`{xh~$93VCB4x|%xUF|",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "r|7Ut]MH*b5F=:k}@f9G",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "F;3}278jD0p3*sTI{4m2",
      "name": "@Map/Progress"
    },
    {
      "id": "Sx3G:(*b%O#qMaFzvg}E",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "ZLjklQM,GUL:jMfK6@S$",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "L+J%.2mO*4K[Y`8^$Ig%",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "y%^#),PmCfYi6]q$b6?]",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "{;i~D|4(`aC|,$3Wf_6k",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "xk3O0U[Gio(V!fEZ4:v,",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "2|dZmqE@zQDav#?upVY`",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "O{H{u=vTXW#)jg#(v0Fy",
      "name": "Map/DisplayWinningTeam"
    }
  ]
}