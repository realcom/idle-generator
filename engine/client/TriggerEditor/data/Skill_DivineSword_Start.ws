{
  "blocks": {
    "blocks": [
      {
        "id": "Pv,7#.oj7UMHzzwv@;Cn",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;slot유닛 여부(1=slot)&quot;,&quot;name&quot;:&quot;Value&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:GetBuffByDataId",
                "THIS": true
              },
              "id": "Gpu{D:~!(B]rPWO)YuI]",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "6?t,[tb:H7Q(UKK8Ak^A"
                      }
                    },
                    "id": "[}_H`BS3zxcyVgn!{8+s",
                    "type": "variables_get"
                  }
                }
              },
              "next": {
                "block": {
                  "fields": {
                    "THIS": false,
                    "VAR": "buffVariable:Level"
                  },
                  "id": "4v?wU~-wP7o.egnz={Z/",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "OP": "ADD"
                        },
                        "id": "G!r20@9)a#Fr9$esL/24",
                        "inputs": {
                          "A": {
                            "block": {
                              "fields": {
                                "THIS": false,
                                "VAR": "buffVariable:Level"
                              },
                              "id": "~j6Np?_^$jG#VjCf]`M|",
                              "type": "variables_get_reserved"
                            },
                            "shadow": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "5i|HPEF|5lC-DjcUjn0H",
                              "type": "math_number"
                            }
                          },
                          "B": {
                            "shadow": {
                              "fields": {
                                "NUM": 1
                              },
                              "id": "4;bL~%h(Y%K#?}+yaDij",
                              "type": "math_number"
                            }
                          }
                        },
                        "type": "math_arithmetic"
                      }
                    }
                  },
                  "type": "variables_set_reserved"
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
                "THIS": true
              },
              "id": "iAe6AmZTd}8s|$j*-Zwc",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "6?t,[tb:H7Q(UKK8Ak^A"
                      }
                    },
                    "id": "lQ7m9T#a[{tUY`;+uMYB",
                    "type": "variables_get"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -985,
        "y": -905
      },
      {
        "fields": {
          "TEXT": "신성 발동 시 치명타 피해 +2% - 3625011"
        },
        "id": "2CYYdZ;[=S|kkX8!A2,}",
        "type": "text",
        "x": -995,
        "y": -975
      },
      {
        "id": "^1=5E;SmafaA%YPFLA!.",
        "inputs": {
          "DO0": {
            "block": {
              "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;slot유닛 여부(1=slot)&quot;,&quot;name&quot;:&quot;Value&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:GetBuffByDataId",
                "THIS": true
              },
              "id": "Mt},udeVwfK_wKE0v$bm",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "?K73eQOx4#%dwbx8=OY}"
                      }
                    },
                    "id": "gU]^C*:NW:X/P9*dE$1z",
                    "type": "variables_get"
                  }
                }
              },
              "next": {
                "block": {
                  "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                  "fields": {
                    "NAME": "buffMethod:IncreaseStack",
                    "THIS": false
                  },
                  "id": "Q4YulMjUyY:|hZ+!7Ah$",
                  "type": "function_call"
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
                "THIS": true
              },
              "id": "GNs)/|[!*Rp|!%gn,_~r",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "?K73eQOx4#%dwbx8=OY}"
                      }
                    },
                    "id": "5dZL0j)*Qy[vG`O%smE{",
                    "type": "variables_get"
                  }
                }
              },
              "type": "function_call_return"
            }
          }
        },
        "type": "controls_if",
        "x": -995,
        "y": -465
      },
      {
        "fields": {
          "TEXT": "신성 40회 발동 시 치명타 확률 +20% - 3625011"
        },
        "id": "Z3?^N1q.FOQqLJSKn!xE",
        "type": "text",
        "x": -985,
        "y": -555
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_DivineSword_Start",
    "period": "0",
    "triggerType": "0"
  },
  "scroll": {},
  "variables": [
    {
      "id": "+#i-r]WCj3%jE/P|?#?X",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "rV4B:$4-4m$Nma*1J#lo",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "I#EvMO*8z.$/Ys.o*`)H",
      "name": "Unit/Time01"
    },
    {
      "id": "j{b7dJ=5HSmj2oF*L)aQ",
      "name": "Unit/Time02"
    },
    {
      "id": "1_W)w6e@!)lh`mXs*fB9",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "HLLhz;y$KR6_*Y+2@P.%",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "AerHT+/pk}Mzo:2$_c)i",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "#!3u,:*n;hGqcrP2.*:y",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "t3oy6_6~SeTtRZ|J{q)C",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "Q-#8d|!czaYr/6TX:9m^",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "n`oa5B1/X`.uGySqx@SS",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "B_]LeR4YQ-1YQ{r5ux]=",
      "name": "Unit/Tick"
    },
    {
      "id": "%[A/advOs_x$Mc/?G:yQ",
      "name": "Unit/Rome"
    },
    {
      "id": "e%+X!d77FFv66LKf.UYT",
      "name": "@Unit/Delay"
    },
    {
      "id": "w]d=:!GB1LV[A2qHN[Ub",
      "name": "@Unit/Range01"
    },
    {
      "id": "RPAcbPqficdb#{]l]o{c",
      "name": "@Unit/Range02"
    },
    {
      "id": ",kEZct![fNNOq4}J!uZl",
      "name": "@Unit/Range03"
    },
    {
      "id": "?[bp-Fhp|?``p!*cG/N?",
      "name": "@Unit/Range04"
    },
    {
      "id": "%Y}Q-[C/b:OkjG^]HkVv",
      "name": "@Unit/Range05"
    },
    {
      "id": "jUxNwc3;Lq2?`Uz5un=a",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "t~x!F3a5(%Qg`c$2n|bA",
      "name": "@Unit/Variable01"
    },
    {
      "id": "qG|BKuopsEG+PgM$0ZUd",
      "name": "@Unit/Variable02"
    },
    {
      "id": "U2sWP5pxl!CLrf%K[?aQ",
      "name": "@Unit/Variable03"
    },
    {
      "id": "S4hGw=qt38vzh*OMx)Y2",
      "name": "@Unit/Variable04"
    },
    {
      "id": "%9M~{}s=gMa~C0!#_p?l",
      "name": "@Unit/Variable05"
    },
    {
      "id": "2fWJqX3o{`KqnXq_dvhV",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "hQW3%CeIn[ptuXM~Oauc",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "z6|L|H6L?:0nts*_W2BL",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "#j|7C,BDV@6OfUY-HBXQ",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "/YO:mXb?Gb%A|/OS#nBf",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "i}B1_xHPn3))4WMIV%_U",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "}Mh?I#Ak1s*]dqI2~p$|",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "^nT{xf_$;+aNxD}g}^iK",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "0V/;`Qz;w8S;+GTg0}o|",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "j}9_Euv1$UC[BX(43`5V",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "`Q~_dK1JQVXX$yKO`?]l",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "Eo[-hXeK0.^_8utj=^;x",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "%/P/nbqCAb_(N33(lU-@",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "6Bst,At!Ry;B7}kiowJ9",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "h3dyJfKu}?14^CN$J2`]",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "Y-OgIq!x^vxx~Ze`4=N*",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "gNUKf1FLm4Gok`[4I@}I",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "o~U[-t5X~,~Hn*C(C~K[",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "TL2;]=fluO}Z0R.)5Tqw",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "NA/wMcJ2R|nU$3kpH[C9",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "%R0!@||fYU,4{K2Tc5HI",
      "name": "@Map/Variable01"
    },
    {
      "id": "Q^,a|`pyMOGc76xV0B`r",
      "name": "@Map/Variable02"
    },
    {
      "id": "WJ8z?@F#~J3Yu3~KbV:.",
      "name": "@Map/Variable03"
    },
    {
      "id": "Ttmh:k_G{khX*wE]BID%",
      "name": "@Map/Variable04"
    },
    {
      "id": "v8[Rk(VUm,ej.r1{++5}",
      "name": "@Map/Variable05"
    },
    {
      "id": "ipp},10[quspcPI|OyGW",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "rC4Odi,sYr0/vR,^[J-(",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "%x!i]}(?I9^0g}9qaOzT",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "Z`p26s?y_Ej34U/g@w[p",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": ":$BkogBiHSqZks4_B-^Y",
      "name": "@Map/Progress"
    },
    {
      "id": "Vt0`RUg5Tth21z0[b5R_",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "2.9:9QW6!+X^EkwV[(|P",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "rcyzZRYqQUl2jnm][Ur{",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "G(BQzAw3MzZ(IzyeuMv#",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "As/2(l;xv(9dd17e~]8#",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "`^sd,@]/zzHgsPhes?0p",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "scBW2FqMdc!7l1C,pIl^",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "hUo||MO~n{l[4p1SK}.#",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": ";Vvy9`|}B7vUDHR7)Npz",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "@VI(I:l^;JpKJOT%kZ#1",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "E$,KU(Tk234q9A!pi)HW",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "Oc3n(q,Lo;C6brteelhw",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "wgSI3A=y~]VqD]]m#8O]",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "ytrA.v={pK#pPRg#B^-M",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "5+uX4M}$~OCgoc$,jWNr",
      "name": "Map/Wave"
    },
    {
      "id": "arp_ur4qAScN/Fp|RquK",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "!vYmaSoK]8eme*Gvb#8.",
      "name": "Map/IsClear"
    },
    {
      "id": "T|MMlWmf]I]azh]sIfU$",
      "name": "Map/Wave/Step"
    },
    {
      "id": "+Y?izTw[5#*hGgtby4?e",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "jG|h%2:{AZ3L~)0tddD-",
      "name": "Map/IsSpawn"
    },
    {
      "id": "3%.4DM=/muKX=vj7R*_}",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "W6p+caov6}$HWGh:i=}P",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "fK%P|NtukKx~DDw{]9{6",
      "name": "Map/Wave/State"
    },
    {
      "id": "?R(tuo~h`HIc^.L;)!o)",
      "name": "Map/Player/Moving"
    },
    {
      "id": "sza#QxU!K,)+Oye4.N3U",
      "name": "@Buff/Variable/01"
    },
    {
      "id": ";XBO4KcALlIL!+ljXz;`",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "e77^99r0f!aZ^r*M}EJc",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "jBjt13%WwIFD$e2k32p1",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "+LYb`.m~mIb]l5tF}Y[d",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "x)0#]^OlaJ^S{5CFJhg|",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "M]oY6g~pQP}i^|m/O!n6",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "S,t(iphJPN{cgA8ZdLS`",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "OHLw9l?u=+bRD,E2dNox",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "+GO]e:(,+%x?sC}S-+[P",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "c~vVxdTA0ab15Ep2MJ]:",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "7d]joQG~CnkcCQ+K^l8x",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "zlPkgNktrl4k/iH(Ww`}",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "cuD@-BIG797TsH9FCxc1",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "+y8=8:~Jt!,*9pB]m2~K",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "dv%0K_s,_$F8bo?npr2c",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "u|Fs7HOi?0!QBG.yzp;Q",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "^LP~-@is_HO:,d}6dnpU",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "UaA,GzmT!EBcu{ESjrm7",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "Wpe{osR)P%r].F_#jlXX",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "c~B3%r9#gb%nD@Ea~q)O",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "jnw^_lPvsW[d,.~8XYUz",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "6?t,[tb:H7Q(UKK8Ak^A",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "?K73eQOx4#%dwbx8=OY}",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "vO4dVLZ!y@t);8}47KsH",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "VC{ggN9fF7SIduRj,GxY",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "lx=mzn}HR_F{K]QWEVIv",
      "name": "@Skill/Variable/06"
    },
    {
      "id": ";OzCu=nRmrGVcOHw!HsX",
      "name": "@Skill/Variable/07"
    },
    {
      "id": ":G2:jvkze8fR!{)N0q6)",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "IefXtHO$2yd5=uO`vRij",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "19AX6XS82ih9r-!Nrsbb",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "3^XAfvyc:O]+jlY,$0^H",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "z(DIK~*_kP/z)}k?/z3H",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "07}ic/vj6-zwW/JNbNF@",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "Pz}xfqxEq{vCU8:.xbf|",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "N@j[]I]/$^KkNKI]YLhD",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "v_%X8pX|t6(hI9o52kD*",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "RZ%*?9boGt1Sj$WZVyU|",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "sFNq!U4%/eW~yY,b~7]5",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "}n;y([b|BI2R/|Y8rp3b",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "9o3/9#Q[w/YcA!2B_-/W",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "W};Gqex~%}Hi%24d|J86",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "=s~NlTWdNmgG9QDRLn{W",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "Vp657o9LdzCY-6i)|DdE",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "966fpS5{9vgI)Yyv@ef$",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "4Jwh916#u$,U_Cl9ky.O",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "7JFQF|ak]kg.R-:5`,t}",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "CzetG4wim^OBZiW1xv`V",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "FU:Wxw9Dx!zm-M=GR=xY",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "2]Isw=/rG(i,2(x4DxF{",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "GW8nnwdC(j4KC++Thc5u",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "wg[:=D3IAc?.Qr7IFvZ-",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "XfVCY-TYt3SC:Wv@y]DP",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "g,/#qf7u@4E;D{i)r1G:",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "z/X{iZuGZi`p-d:zJ+,j",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "sPWUs|K24;~g(Fc;([SM",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "b_S-0$N=X!-([co,$Uq6",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "]OjpxBj0$cJf5ZrkT7kc",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "|OV!ofB=X.Vj0_%mHq9|",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "_//A14W2t!|ZR;ERpgpe",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "~Ul48dN+7N}4l6F#ef8h",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "ehD[%G!z$ms6Okn210Ov",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "74F|4mW]3C`{N,_xDJ0-",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "K#WjWdrDBi8SJ5.^|r+8",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "4uXMThO{[l.8TZxkTZsd",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "%S!5{QGPtk77@oJm^dn]",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "6)/PY(5VOfX5:UxcnGhi",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "[GWBQ[#3ZyqA3~0%;B/8",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "}+S*Scf(}#jUXSbpq-/0",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "U+!Bg~;3l1`nFlM^A~vU",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "Zz#/donC38a/]d~YuW]e",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "`7nT+o.tB=/,h%h@%3/_",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "EME5SCTfy*bXg[tBRIXG",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "QpEW*?W2u/K|-@%RwDBD",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "_d/r-`Qaj18aF4-mN[jM",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "qh(!y^W(dsN*fO!VM~C3",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "m~1]s-lhLj4qPQCT*9--",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": ":qIBvCH`g7kF;K{@RfE?",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "m,VG8EQqWNV:YM~ZAyAX",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "AY}TlIY3M:cOjavUp@JC",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "VvHt!0wDfx0rns;5RC6C",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "N{-RSVVvW^)0-tV=9f$^",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "h|]8Bpd1+-7VL7+nDe;L",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "VNBl^mmS=py-`vi%Y!0,",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "5?WL7pu|ACZr@prlw/}[",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "A81V59Z,LL6)CgD4t{Ba",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "lteml(jm3Zm_W}FW#`yO",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "c|GtS*_^1Lar`ug6g6[x",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "*y;+Z%Z/_]gz^2J+!@ku",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "udSzK9{`rxmO`e)L.Xq;",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "(.prf$FmeQ/h.[.mG./x",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "`l}*Kh*G#x?pwrJ^s9eU",
      "name": "Map/DisplayWinningTeam"
    }
  ]
}