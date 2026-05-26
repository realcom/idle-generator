{
  "blocks": {
    "blocks": [
      {
        "id": "+Bb(j)}5$s3XV2:S7!A?",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "THIS": true,
                "VAR": "buffVariable:Level"
              },
              "id": "z)QD]x!{$9}yn?3[=e9j",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "OP": "ADD"
                    },
                    "id": "fLt)NZEG$DA0n6Sb`=}b",
                    "inputs": {
                      "A": {
                        "block": {
                          "fields": {
                            "THIS": true,
                            "VAR": "buffVariable:Level"
                          },
                          "id": "L.2Z|qkK@)+J9XLAR,S?",
                          "type": "variables_get_reserved"
                        },
                        "shadow": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "wmr.`QN3J2|2.#~#43~W",
                          "type": "math_number"
                        }
                      },
                      "B": {
                        "shadow": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "?d_)Odb/tN2Db4-@gX,X",
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
          "IF0": {
            "block": {
              "fields": {
                "OP": "AND"
              },
              "id": "T#^_Ig(0xy`.cO`U%%Aw",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "OP": "GT"
                    },
                    "id": "1J8zvQsfcw[kl-^n1cqi",
                    "inputs": {
                      "A": {
                        "block": {
                          "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
                          "fields": {
                            "VAR": "Damage"
                          },
                          "id": "IV*VcnU/;v-?aMJTfgpe",
                          "type": "variables_predefined_get"
                        }
                      },
                      "B": {
                        "block": {
                          "fields": {
                            "NUM": 0
                          },
                          "id": "riF;%_ilg}9A|7C%XeEW",
                          "type": "math_number"
                        }
                      }
                    },
                    "type": "logic_compare"
                  }
                },
                "B": {
                  "block": {
                    "id": "L#$:#j_C:?I0a4Nl=0b2",
                    "inputs": {
                      "BOOL": {
                        "block": {
                          "fields": {
                            "THIS": false,
                            "VAR": "unitVariable:IsBoss"
                          },
                          "id": "1ERZKlkppc$)_dpI_zW;",
                          "type": "variables_get_reserved"
                        }
                      }
                    },
                    "type": "logic_negate"
                  }
                }
              },
              "type": "logic_operation"
            }
          }
        },
        "type": "controls_if",
        "x": -825,
        "y": -955
      },
      {
        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
        "fields": {
          "VAR": "Return"
        },
        "id": "`fo.XMLMc}{.#Croj7Ic",
        "inputs": {
          "VALUE": {
            "block": {
              "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
              "fields": {
                "VAR": "Damage"
              },
              "id": "):ev[f{NlMehO_jqn3Xr",
              "type": "variables_predefined_get"
            }
          }
        },
        "type": "variables_predefined_set",
        "x": -785,
        "y": -745
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Buff_IncreaseBuffLevelOnMonsterHit_Attacked",
    "period": "0",
    "triggerType": "3"
  },
  "scroll": {},
  "variables": [
    {
      "id": "lk,*,C0Bv?/*_IDQDH2l",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "SJ0S.l;dZX/0U#sARA#s",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "^q7kUNbB|ej(./:``n`R",
      "name": "Unit/Time01"
    },
    {
      "id": "+LQqwE$`RN?.S#!)2,~(",
      "name": "Unit/Time02"
    },
    {
      "id": "ifSQ3A#B+$=5:ri.2:X*",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "yHsy`V-y=XFKN|d.y`5(",
      "name": "Unit/MonsterID02"
    },
    {
      "id": ".w]M:4IbpwNL69G*c~wL",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "aLkca/:3f!p5at=p*d%a",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "Itq?lFp_hxYXqDg#IY~x",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "$RN(OXHXg[wP{%_*A6U(",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "UVcv3Y[RjsTlMn{f~t^;",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "=dIEhZRM|j91.bew}/We",
      "name": "Unit/Tick"
    },
    {
      "id": ":)@IuuR.V6Xz@s]=8*,i",
      "name": "Unit/Rome"
    },
    {
      "id": "qkjjqa|M[1V^D*cR.t$)",
      "name": "@Unit/Delay"
    },
    {
      "id": "I~dVBDbTwdP;bNui$m+H",
      "name": "@Unit/Range01"
    },
    {
      "id": "Kphg{V}P8js9@hbm_AMf",
      "name": "@Unit/Range02"
    },
    {
      "id": "14MspFP)5}E/4MlW_8Aj",
      "name": "@Unit/Range03"
    },
    {
      "id": "@KjQ@[MT_3N6eTv@[6y1",
      "name": "@Unit/Range04"
    },
    {
      "id": "dT)FD}xpA+ImL0*sTUW/",
      "name": "@Unit/Range05"
    },
    {
      "id": "@XO8Wu7)+4grxus|FjSX",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "o(0-bK_+VDi1yoFF:FPz",
      "name": "@Unit/Variable01"
    },
    {
      "id": "6CU.:{I-RTt*Md:rCh6+",
      "name": "@Unit/Variable02"
    },
    {
      "id": "bu@oGy.$;tu{5#,H8dOE",
      "name": "@Unit/Variable03"
    },
    {
      "id": "NFRwf2lIDjo}ih;SHwW%",
      "name": "@Unit/Variable04"
    },
    {
      "id": "~R5VC1)2KvY*RW4B~6]U",
      "name": "@Unit/Variable05"
    },
    {
      "id": "r.qed*|@2AZD.9cUmk|U",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "5m%]n|j52MlJA[4,3FPg",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": ";luSa)9+I{^D0HrtP3#W",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "!P;bmL!s1nH3C!`!b-R!",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "fh;HGLaxN]:zOimWv6sD",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "h6-G.6QsvvTd(XZ8(z@/",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "WWS8|7:m4nT|`5*JMT+b",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "nAe7U?J0X}+qrBznEtr3",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": ";]sad$$xsy?wG,HWG|y`",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "v3Xmn9[044y`n])f5H{Y",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "AEVoKM7Ap^lC6!Txaa5)",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "W2XZcT-fF0W{wuTHKN{J",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "YP{|9Jge]/X]}nR,C=Zp",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "SXoYeZC|Xh]}]T^kDjJ(",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "YYyTFF*69FV!*4]bvOtn",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "u/a+;/4.f8M2$o2utZ4#",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "dIo5]hMOakB_ea694+1s",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": ":~U6EUg7[u?]Gb,{}A7J",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "@(ENXVr5~@l3ed$kNs)_",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "ShuH,_3)kP]3fb[B)hIk",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "DiNv(.BsB}%uY1xF$^,m",
      "name": "@Map/Variable01"
    },
    {
      "id": "wLCTrOk~WT.nGe3D3[C=",
      "name": "@Map/Variable02"
    },
    {
      "id": "*s-0MlIishlvwa(g+s#S",
      "name": "@Map/Variable03"
    },
    {
      "id": "!dOEB2eXYPPWuTeaiI.G",
      "name": "@Map/Variable04"
    },
    {
      "id": "1)(.C5=;i*1yL@d1DzJR",
      "name": "@Map/Variable05"
    },
    {
      "id": "gp^JMV`BT3,[XmyW3uW5",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "@AVC^o}Zi.1c3VsU/e+j",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "8|j47:#x#t=$nJ~j|30,",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "zlF^oB.2O+;Wa^cxH7M-",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "JF^)Pz=nNl9fj{%CnaSq",
      "name": "@Map/Progress"
    },
    {
      "id": "iyg^l`OEg//|w!Gu$,FB",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "*}oTrsUhmwh/~y)~F7!7",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "P/R^B0*jY{zsZ3kH9:Wg",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "+Qrlx5,}.]YdF%2#5x9+",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "(HS0.LMh$z;maJ|[DmU;",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "mc386aN6{}37q++p^3:!",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "mTxLc4hevaztE^EL}`KU",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "/BC23TG_~Q~0+48h#@8T",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "T^!}2vEbjI}wleiF+ST(",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "SuG_eT{N|aVz9e[!NHEL",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "D)iT:.;/Ovz*IWH^NEUl",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "2)rp8eVhg.2NG$,G)c;K",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "i,hhl)BF0;lo=(lKXfgb",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "SJxFiQ8:!U0j0h]n;f5S",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "wWAua?y[@D}0HSyOU=}v",
      "name": "Map/Wave"
    },
    {
      "id": "Xb_j.WwlrRo375={}2F#",
      "name": "Map/Wave/StringId"
    },
    {
      "id": ";fdb/B}Y?LLjzhC~K:Js",
      "name": "Map/IsClear"
    },
    {
      "id": "nm1cqIxHhS=dHJ)?4Yyn",
      "name": "Map/Wave/Step"
    },
    {
      "id": "{_)^`f;JmwW|/ce^)IVa",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "6kBdshz`ww?9KOoBR8al",
      "name": "Map/IsSpawn"
    },
    {
      "id": "nXG?R|50oGk,?$w(4{[[",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "q@-#1X,an.*PAkh(0!H.",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "0c3|ba#0[MT*SKwaQayk",
      "name": "Map/Wave/State"
    },
    {
      "id": "[Ag-m%f*%+Cm5OzDIwT;",
      "name": "Map/Player/Moving"
    },
    {
      "id": "uB!^+B|bA_?0fsv-EF9q",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "0!q%ilf/Q/B+E0t*5(SG",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "Gy_i9Ib/J%b4$+iFk*`#",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "pP(HY5{+W$9U{;~d-o?x",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "T2S.4OY@Y__G`/HjQkov",
      "name": "@Buff/Variable/05"
    },
    {
      "id": ".;S3tXd0wu+IzWX_eNP(",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "f~ZE6p14p#2l^}@58;@!",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "sW;fp2;FBOA0V5d)lhg9",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "wnLOx!c)k-F-%7)Q.g/z",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "dBmE1;/2=1kYLu3MbtCC",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "R`sZ/+IopDs_Tm/Q{-2L",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": ":A}TK(|;bKUb6[@^NpJI",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": ".jth$YIAs8{RiWM2KAKh",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "yF|y}cc/mMR58WJX%tch",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "7l~EBS%%78dwGflNrN=S",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "Fjo-oyuH@b%Z.oZP/@;#",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "IL+%mkww+_|60*1q!*#1",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": ":AcGI/Tu[Ubo4a%?DyNT",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "2vcDQ/`dL.(6ywa(~]=0",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "q~n9/s}dy;DGwjy(Cu~m",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "TaoPe_{U3Ir0}|.Bvr}F",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "G!Gy,:lmIH#w1FXEN)LR",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "H+onLkf!xp3z-c7rPz9I",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "(*0i|OE0QLeZ=}jXGZ3K",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "pvff:aalq8GIh[s3S8Of",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "jOq.tLE((hs?)342I:E7",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "3,Re.!xM,WA9M9g-OO8X",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "iQ_C%ET`/ubD6-3-8@}G",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "lepcY@F9Mvx`#~C`2Ku5",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "/zw-p(tyU;AVvO3Y7wvD",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "%SbB@vj#6:|yl{*IVbf)",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "cw*3CO{c7azDT]IMpj^R",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "YB%/x|[Y8u32vGm{Q4{`",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "ysTbp`+g+@L|UE1wQLkZ",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "]~GfvU2lRz=`Q=9,-kZ}",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "ki{]p5IAfS?XCE^:`gGI",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "H_;D$2!]@FFi.ootMmdc",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "+!8*qVhboYATcZ9S}-8Z",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "v}lZDm`jS4H*dIcz)Y={",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "$ppaKP8Bd$ds8s}39%z/",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "PK}H(_d6*Fn/#$`%()ye",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "l^{u?(T5`qmyf`W,,xLw",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "ae3!d[T}Dql#}*~8KyQ-",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "-wGi;V9?.xVS.r,X4P;Y",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "4,G1g/`ReqH+#jl-lYg!",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "20;!xXHr8?tVP|ZjD6LN",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "EsKTgw.GV]I?|-x-rU,L",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": ",6q~O}B$C)Z+}9cYoum^",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "=yvZasQO~o)nD6+U8Y3s",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "DerTSZX#ZTi821LV5sZV",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "ap]O{Bo,cknkR.}/s9nv",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "N8hk#Pi37ujQoBz-7Hzp",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "4wx~zaoLEUm$s2(7,heE",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "N`%[/%qn}q.JMqw+AE1y",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "3N|FBLeTGz_/xfRaN}#!",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "8[;m]8*Lq~mOYuWwT=,a",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "RL*mWetf_tXeUdHhVgc(",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "RyL{~)ez[6jF~JB-Hw^3",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "!EE0WM7QL`j0A#LbA%db",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "=bb4eI?WpQey%2gxoPzK",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "$Dz%HakDjNrC=2FEAN4/",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "Se]ueld4Li`3a3=upUyH",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "/JRRUna*6sU*p?MI)G+(",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "g0E0Zk*MCm@ql4;4j)(8",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "t0q;w!0wLS$@A]4RI2be",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "U#l;0;Fjdn*vbT|SLU*`",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "636G_n0_3~Z7TiDPon4N",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": ":4`^.ho|1L:+x]x:[UC@",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "{@L{|pX[dFNtLUkEweN-",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "ku9iZ/8PUGlh~,g-wQ_[",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": ".o4.369%KF7##u2xeB.:",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "LK]};]]ek`@elmb,;1Q9",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "?I5abzLIb!Wo,+D-p[I8",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "2HyI9G:cj$aA[:r2@7n}",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "uO*!B!sSN58[Wu^D#a,m",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "yXw/1T,LNN5RA9a}vF1Z",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "D+/d!FxzMrY|7BqqAE0$",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "P~4$Z#Xh/!I_y2yR#L?B",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": ",{wi,-@5RLjBw8:j_#sV",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "MI~`?tg+glfDrEu^X!Pu",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "L7vea5B?M+_%C*)}^kO!",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "E^Pk`.x=P(J)=-{W8oS_",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "/Lt#eALQ:S]dQr7X~y4?",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "?]ufhnx=AqbJZEdgo$h!",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "2$=K)tfuZ)XqKXr=Z$Bd",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "?)IQ..O$hZza?0r=VQF~",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "h}Vkj,/#-9IM;~LD9j+h",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "kozaFwPq@;m}Z[kFW9x.",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "nHKwHzP0ai]7s.B!ilzv",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "jEH=zf-yvcVwV,hFR|xX",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "5(a!|8Jyw^P1UKlMgv{K",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}