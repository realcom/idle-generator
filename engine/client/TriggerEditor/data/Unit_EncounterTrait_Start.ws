{
  "blocks": {
    "blocks": [
      {
        "fields": {
          "NAME": ""
        },
        "id": "F``I:2)l()$yvl`,~HN:",
        "inputs": {
          "TEXT": {
            "block": {
              "fields": {
                "TEXT": "Kill All Enemy"
              },
              "id": "/K|bX#qrsMd{oRMN+UR,",
              "type": "text"
            }
          },
          "VAR": {
            "block": {
              "extraState": "<mutation></mutation>",
              "fields": {
                "TYPE": "caller",
                "VAR": {
                  "id": ":,4*;4o7eL.@jF?WLVR$"
                }
              },
              "id": "e3{.gOfdJ4Ck]jJ?pT%J",
              "type": "variables_get"
            }
          }
        },
        "next": {
          "block": {
            "fields": {
              "TYPE": "board",
              "VAR": {
                "id": "v^5/g96a2#VApFJ,1NTf"
              }
            },
            "id": "/Dqx$`fS{/trz/V0feWr",
            "inputs": {
              "VALUE": {
                "block": {
                  "fields": {
                    "NUM": 2
                  },
                  "id": "AhC1oIg~f+E!fBr`|96Y",
                  "type": "math_number"
                }
              }
            },
            "next": {
              "block": {
                "extraState": "<mutation itemCount=\"5\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;DirectionX (default = unit X)&quot;,&quot;name&quot;:&quot;DirectionX&quot;},{&quot;comment&quot;:&quot;DirectionY (default = unit Y)&quot;,&quot;name&quot;:&quot;DirectionY&quot;}]\"></mutation>",
                "fields": {
                  "NAME": "unitMethod:UseSkill",
                  "THIS": true
                },
                "id": "fsOX3v$Ffr4F#Y=!6Y@,",
                "inputs": {
                  "ARG0": {
                    "block": {
                      "extraState": "<mutation></mutation>",
                      "fields": {
                        "TYPE": "caller",
                        "VAR": {
                          "id": ":,4*;4o7eL.@jF?WLVR$"
                        }
                      },
                      "id": "Q@)0G3mXLR4{T{+AIT:Z",
                      "type": "variables_get"
                    }
                  }
                },
                "next": {
                  "block": {
                    "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Duration (필수)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
                    "fields": {
                      "NAME": "boardMethod:StartTimer",
                      "THIS": false
                    },
                    "id": "5CB20edAM_H$VaH5n@9T",
                    "inputs": {
                      "ARG0": {
                        "block": {
                          "fields": {
                            "NUM": 1
                          },
                          "id": "+rVId5V@z%+^AF=#yrms",
                          "type": "math_number"
                        }
                      }
                    },
                    "next": {
                      "block": {
                        "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Position X (필수)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y (필수)&quot;,&quot;name&quot;:&quot;PositionY&quot;}]\"></mutation>",
                        "fields": {
                          "NAME": "unitMethod:LookAt",
                          "THIS": true
                        },
                        "id": "$^CWay_ON3zxM}[lijmb",
                        "inputs": {
                          "ARG0": {
                            "block": {
                              "fields": {
                                "NUM": 0
                              },
                              "id": "@qwy}O+iU^R39*]Ir[We",
                              "type": "math_number"
                            }
                          }
                        },
                        "type": "function_call"
                      }
                    },
                    "type": "function_call"
                  }
                },
                "type": "function_call"
              }
            },
            "type": "variables_set"
          }
        },
        "type": "debug",
        "x": 715,
        "y": -1415
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Unit_EncounterTrait_Start",
    "period": "0",
    "triggerType": "0"
  },
  "scroll": {},
  "variables": [
    {
      "id": "|LsQGncCAmeH!`]}Si:#",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "V!NX4kl!%cOe:x0)8$+6",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "0^fl2Q4*Fn0_nuk4j.r{",
      "name": "Unit/Time01"
    },
    {
      "id": "3R`|!K~@qyLq#?~AD:`(",
      "name": "Unit/Time02"
    },
    {
      "id": "m!i.osJ+9-8I]j1lav]{",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "F*0;DREzF5p[N}UwS]ny",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "%/RrkSm`=@1w:VGL=n@f",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "bLUg+^M3hB?XYa;vRlIH",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "o#e2(MHBfGGD?EU=MM/r",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "_KbOM=Et8c?LEV!RAj]y",
      "name": "Unit/Tick"
    },
    {
      "id": "g(p~PDgmi)i.{+mmo-y7",
      "name": "Unit/Rome"
    },
    {
      "id": "=RRkt+kk/_fiNZ^u*GKO",
      "name": "@Unit/Delay"
    },
    {
      "id": "Pay_7!JKZA9EER:$c5gT",
      "name": "@Unit/Range01"
    },
    {
      "id": "oua(;Sg[Hq@tH-XqdXO@",
      "name": "@Unit/Range02"
    },
    {
      "id": "2eJ7!cxq7w4Be6[:$Vp=",
      "name": "@Unit/Range03"
    },
    {
      "id": "yP,{I+l|FfE)lMWy*W^V",
      "name": "@Unit/Range04"
    },
    {
      "id": "kgZ}PB(H7Nzi~pcDs_(n",
      "name": "@Unit/Range05"
    },
    {
      "id": "aVgVF`()p:,|2Ks=K/o}",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "G,fBPws0@FF)J6eGQh`h",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": ":,4*;4o7eL.@jF?WLVR$",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "=NY,az[J3@u)Vp)ax{ZD",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": ";UlgkS^87Uqp}kN-bFnr",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "jI7EG:szk$|$k{yJ5gd4",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "@W1n:yn1)Xb`OLl5%-Cl",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "pr5k|dO0A8s{3UDM9i_y",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "4dUvEBO{y(B-WWJa/Ce7",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "ayW{73^ZWA#cq9h#i.{7",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "xwtZWt|,W{}i=+R?k^UM",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "@o#mKp+;xtY1k|DmkF}d",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "%P1rx}nr^EU`-n.XQ$bv",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "R/2[%@v5,j7c4OdNTBxH",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "NcS%|h[N?8I9pAVGP{L$",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "K%d_]9Yp2Aa.wo@L$+NN",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "WX.v}53V3wIlXlZt2W#[",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "mRwm`Hbs6%sGZO`J^FGA",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "^a+yQO]8p.uL,~JijZ;.",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "RofZhXHV?%wj.iPD*;d7",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "lJAMMllGUxywPR@%/L_J",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": "UE]K_-|Lcc`Jb%/X5y5D",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": "h9ixviuu;,rV?0J1B-Vp",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "lwUNw#y2@o1=uNWI]a.}",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "qA`?G$d3oQZaDj]OVAip",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "7zaAK,)%vuT(g3qJ!l7~",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "RFH[xmDJ]B-|[SR?6zQ]",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "+Gx2mW=YCf6uAY*0gp+C",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "$=_d_!$)g;}L5Uu8Il}I",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": ":+]QSO;q09jemMZ*d]cf",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": ":wK:jdpa=vKCt0CZoCBe",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "}%QNl[%xe%`#m*]0Kpc#",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "*k3eW$ZJg5Ut,G;Lbg1V",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "x.zG8|CRoLlu*vKEOSk9",
      "name": "Map/BattleValue"
    },
    {
      "id": "VtnZUJ~]7F`q|[1Fz?0e",
      "name": "Map/IsClear"
    },
    {
      "id": ".hl7:q/LVZHwdyyci71a",
      "name": "Map/WaveCount"
    },
    {
      "id": "m0SZ.K.{F9wN/OMhgv`_",
      "name": "Map/WaveTick"
    },
    {
      "id": "wXfTT~St.)U5fz:B#5OB",
      "name": "Map/IsSpawn"
    },
    {
      "id": "G/-ijVc1J$K#DEh_;[@r",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "`{uM8X%ey@iO=q%O%wEZ",
      "name": "@Buff/Variable/01"
    },
    {
      "id": ".NpB3SiM~),WaCyK6fSj",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "+e;)2n8Zszh?%XFk7f2a",
      "name": "@Buff/Variable/03"
    },
    {
      "id": ";PvK#ToqwoohpQ^j7OO{",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "k(!U$wO/RyU|K8xdFB6:",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "tPTgcm1Dm6G]_vSqK@xe",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "QK.N%DTjc!!k{4lB8`dx",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "O1rjx`O:prnhD1kli8}K",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "r315e#eQADC~wrWSsC%6",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "+!!Pj!(!Yl2`ei:1`OIj",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": ",]2Z0gIZ192l#A#26kOw",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "]421+roqTEudY59c[8A2",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "r%p3CwR4L4Qjb^?LEn,R",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "FgjjehoSn4Oa}oFjn3qD",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "zM~,[C{]xOvm/LgS.nJH",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "Zkjl{a~1=1KU^_}taRE2",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "MNp.EzIVJc={/u-]6{_n",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "oF|%,fqs=_?~#.8;7,e}",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "?;6}Mu+)hfHe)`:Jv5Z^",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "w?^H!$fbII(OuV+,Xt-:",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "zgIvG7a/}DSf^W^d/1nc",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "7HLv8UR-AB?}]JXRo1Jm",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "ZMDRv]U]Vrb6Vz6z+cpW",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "`1}l|xv|gd|jG/n6^VI:",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "j!CwRr!T*|(:1-,IS+J7",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "Th$XfAuNJVHtL1{_GTf7",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": ".Xw1OW!b#8+$)B);-tqS",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "BV5$$7j?SSHE:wO$fYLf",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "VeQ^ainjxWX1ZJ@o0iR4",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "1~%u-W#rj{xbKG[U1QbU",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "HF__uZgV9ttk^IOdsRtq",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "zyx-}l{mt*m2jO7;9GvN",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "_e8@?9!kuVVB8OY(p,Nk",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "I082V*nY0I#4pQN=N*.d",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "!$QVW,r`:RKcyGbw2XRv",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "L1UU8r55)!cN[B!Y]u68",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "T5=sxh^Xlf@p^)xlph/=",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "=3ffutn$nmhsmPUVBE5k",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "EHqTCMp)#Y!P+LOQUeQb",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": ";^G[]flZ[zyTWjB)|M7{",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "Pr,V5q]]F+}~=vf:^f^S",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "1SKMqmr)cxJHS*2]]Fyq",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "Z5YLghPN*fywzx}Y%uJD",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "/1o[;rtglh!D!XQz8Pj`",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "0`~MUxOJS^IR!s%c9s2m",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "BwL6}fHg+j?N;h]Ohyp[",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "Fyu?qbQa+V~^@%]aC+0|",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "$`FRE8I4qs}(ZtHN`rJJ",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "DKZ!%J2ChbS)/bRsrvmG",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "{VsRjTB4GG)Px%S0n0kA",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "9S[$}ySbM[uEsvQz{]0d",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "QAais$wM7F!*Rqx.U=Z#",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "/v.8ZByh1e+J$~PO:U22",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "dQR75Hd?%JZ^C1y^GO}B",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "I17W^({$HlfG_.%G|2[@",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "8Bscru}wh~74-i6+]Jur",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "PpHv%Y}8OE72wm{MEY.6",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "e;?[1/2BYS_xq[CYQ6uS",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "I~N}ID.0MoW#UL;Kl!2o",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "+L1ub6eOOm+HJKp@hg}.",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "5v~_qR74s%);mFwt}:Nh",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "xXQM[G`69mqzTet0;BR7",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "?+bRRs-cYeYw0`mi$vsd",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "*q_N:Dp(Gv[_23mi3A+m",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "oy15#X-jahl%3]#W%8W.",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "=1D#~#RwrF[(ekEngU|(",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "oYQ/s39+e5!#i-hIge}p",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "w^;?X4HxU}vydYoIcpBA",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "X6=#fX7KjB1rXN@RFeGL",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "-Jf8X%~hupP3LT+Tf`Ra",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "l-tb2V/(o75H{vj.t3zP",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "0|(FmZzAyd^sT58Nm)ll",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "r=R,sZY];?JZ2O!7T_Yj",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "faBi~(TdIlDIis/OLnw)",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "2lL4IEW*V{dumz=XEEL6",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "y1PK2@2_VL58rj|;+]cS",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "S{JiKa;l{eViX-ouz^2s",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "Bn+@QQq`eN/*gitzIX@e",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "5cp@M?#30Cz}#3Oc_^=+",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "W4J3]GpV)WjV2HKYTk=j",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "UD2ZkNe221WND{=ty8ua",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "=7Fd!_]t^o2Hp{sdn(qv",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "Cko:A):aEw[{#]nxl1Ym",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "@N7b?[M@apNnZV(5FaO1",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "hsZVHfw^j@QWrS2~jTH?",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "eYK{*{]Ot3r`KUf6}55.",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "$3.Ti0@l:uZ4{)gc]~RA",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "Oq=O7;eNKY~[ma-^N8=}",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "9s~YRd!7S`!;n=j;..)m",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "S%tM.844+T!AK[QbshFL",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "2PMUBT:)gV|{om_Q_mT`",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "-PQM^%KmuJVh0E43@KE}",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "BMyisQjg/DecWup0cZzF",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "%CMgywYpEOx.45S{n/l1",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "=vDo_}K[_`c%%8X9cKo6",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "^j^E-U*aF)?PV6N/(140",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "wzY|e/7z!PBNO38-2q#v",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "lcs=vV~Pwd/*i#R)TkPW",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "1G64S)leX}5{[/^+9Pgg",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "Tr(XywuxZf-Dpv33rDQJ",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "}Bu`mj?UX%X[;Q.]l2VC",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "Tkxx%`Pyg{?_PtosEFe;",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "BYZoarFh.T8KEBMkH[hI",
      "name": "@Map/Variable01"
    },
    {
      "id": "iI~~NTv*W!U09I]k}r#E",
      "name": "@Map/Variable02"
    },
    {
      "id": "Vwkls}~B/{I(7Co($-:)",
      "name": "@Map/Variable03"
    },
    {
      "id": "f]l*X#pLV`uawNrbz^%f",
      "name": "@Map/Variable04"
    },
    {
      "id": ")x$]yYTeg.vu!xY*_kl4",
      "name": "@Map/Variable05"
    },
    {
      "id": "p:wgb7HH;9A5]D/Pd`xI",
      "name": "@Unit/Variable01"
    },
    {
      "id": "m))ap=c(%C4_y^w]Z#u;",
      "name": "@Unit/Variable02"
    },
    {
      "id": "|*?SaKo#h#Z9_hfS%3:4",
      "name": "@Unit/Variable03"
    },
    {
      "id": "R5(5dfTEpKTYPIuC0+w#",
      "name": "@Unit/Variable04"
    },
    {
      "id": "He401Rrg5t?Le-KPw38R",
      "name": "@Unit/Variable05"
    },
    {
      "id": "v^5/g96a2#VApFJ,1NTf",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "E-HC9SC^c],FWc5^VHGS",
      "name": "@Map/Encounter/Variable1"
    },
    {
      "id": "!ItqjZSqRoPo6SE{1:FO",
      "name": "@Map/Encounter/Variable2"
    },
    {
      "id": "@L8i_:}+a@QIa_O?YZ,+",
      "name": "@Map/Encounter/Variable3"
    },
    {
      "id": "2%bCnK`7%Kw~(PAuD7j`",
      "name": "@Map/Encounter/Variable4"
    },
    {
      "id": "*f8O_-9EP=%FI^$T#pT$",
      "name": "@Map/Encounter/Variable5"
    },
    {
      "id": "4@e@.hynC#Bd2rGUq029",
      "name": "@Skill/Trait/BlastIncreaseKBPercent"
    },
    {
      "id": "TRo;XZQ*7kub4a/0//MM",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "/*AN}t)D^IaasU,$p4(-",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "ra01xt]YNL#x(BBr.uJm",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "zLc3^e)7ChLZ/tePOP%,",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "9$$?(N[_8H7ULG4PdJ6v",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": ",QoI1`o.rlrayHqW5z%-",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": ";T0S7j^}#(jx(5rd11dj",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "]ms7,:?~!Z7f=@C,fjZE",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "]gde8c8`j{HBAfP_3IzY",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "{Jkd6DtF0wT)Y2sClOW_",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "LA#tAD19#s9ll+i$IUY6",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "Bu=t8297@tFw,enop^:#",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "{H=gW:`1+F%#!`G9IH)+",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "Syl[ta*gY,vWco|]GQ;N",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": ".oK[##_WXvWQ`:3G2hZ`",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "n:YHaSIp~C:Jq?MFp`}1",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "U@oJL/7jE(.3a^o)dTk`",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "xfj:rH^gDwfMVECO4V1{",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "{bK_;Nxpt#TxO,e0)j+G",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "8JglS_4F8m3WBHx}BQ+a",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "T:YxoPGdKtJhuAtZk03!",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "M~]OjH6sbXZE9U~5G=G;",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "G9,AV{ockZ`3yha:)9NB",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "J.g1h{o74D}z(z#?EM)J",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "J]AV`1M301jaDpc)#=ce",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "h):jvSeUX=Rk5RK1;Jvm",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "NmbK^04(u^Z++MLjlxLY",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "Z*u:|fV?FD%eYC5sg,oj",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "5In)pT.K=Q90cMfF;kRW",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "j$7;N2^6fF6S,|`uK7F9",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "kkciebaLX|i(t)N0_^Q4",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "_n`82ejhnasu51h#]maj",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "x8hx}!_LBE{QjYRQV6ZI",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "r[JHAf`}exq^cr.lJMd-",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "GHG^7Vu*`c3B:et}[w#@",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "jM.zfQbXo34-jm}~()`e",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "2A,l[_fe|,HLVWys%-,H",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "@FiR`m}Y2*k!}GdEqk6+",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": ";B:QpNfY74l8?M%zN;iX",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "SRIN)i_k|7^b-$#ehtPS",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "a.={lp-XZUkU?7Gt}:yZ",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "+N{~w%:fN7z+vIJ_0UDY",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "!8+H#;a]!:VjxIZBEe(B",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "/RuT^./gMf)6K]`BUcL}",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "qlhpc)`{f`Z^(%A.sT_}",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "w.0HvSk*!-BrvoRTh+qp",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "}w6HdC39AsCm1hPu(G6D",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "XS+90/am@_XO{/Rc1%t:",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "E$PT~aZQ{ifKT(OF+4k/",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "ptB$h9QCOX:|M6#eZ,Ps",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "ebBpbo!wpEKVj2E?ri]y",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "MZpAfe%_`dr9$0LEXrcU",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "))6tFt1_]i)/0.DOHTs)",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "RSNmtuC6txCf`6dFUnX~",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "jn^h59l8A/}0[:apLVu.",
      "name": "보석 상점"
    },
    {
      "id": "GTHYXv,?@I96mWJx-!W*",
      "name": "Map/Wave"
    },
    {
      "id": "FttRB{@gphnpr[],6v1a",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "a0)5lVkUO6lO.z99|3Ih",
      "name": "Map/Wave/Step"
    },
    {
      "id": "V}^{h$dn7t~2,;CKF5Q@",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "acNF3~VsqOG,M3b)tFpo",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "}T`$JjKU4ICD7A3Y8/z]",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "3]F^p;/=nr:@W0dvu,g-",
      "name": "Map/Wave/State"
    },
    {
      "id": "M,UQW8uwb^BmHaq+e.mU",
      "name": "Gem shops"
    },
    {
      "id": ";DH=WKqq~%jfCcrz[KA@",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "PK}:.GO/)3?Z|uhJL,kt",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "WMzpZV8#jtUbBmv.8fAo",
      "name": "Zem"
    },
    {
      "id": "UfOFr6_~mqSV3^DO!4]N",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "82Ws?cNLEZ$EjQyX}M~@",
      "name": "Gem"
    },
    {
      "id": ":+)|fC-lGcp]lQqT#6)K",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "o+26-T#-oEJApsPvj[w8",
      "name": "Map/Player/Moving"
    },
    {
      "id": "R%fbi97(vk[nvX|`Whm5",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "IAovO6y[1!C}g9GNFeNe",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "SKU(yRUvSUeffbc{Z~(X",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "{_g]JZO(moux0?x4p6dY",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "{sURx86u(+$wtI0Yil$]",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "OfsQ7]wK(qkFhVCoO1J.",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "j$evm/^E`FB?Gi#.WsFG",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "AZq.H#[=(Ffz^PLD|yLh",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "N1QEC+S6[GgSau_S-L.C",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "dm:,Sfk{P{sKE4S4@M?{",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "j%?Vfl)x~GE:hJnAj)rB",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "-YY4bl=8j50,}gcM2??Z",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "rropO7sEL,~~z8VJQV~j",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "p}Ll~Fkh(+aMk3U$4:E@",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "~Z/USXcui0UY44Z+dTA|",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": ",CHiwOt4+KGmHZ[[}9N.",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "H)3y!$tq`L-qOxIqy^rO",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "VN6,v3^5K9Rf)$?==zus",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "V3#/37(7X~mwdtIqL;*/",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "IAat|^h:;jY{PipZR.$H",
      "name": "@Map/Progress"
    },
    {
      "id": "Za*H:oCalxLl+S]pP/f1",
      "name": "Map/DisplayWinningTeam"
    },
    {
      "id": "/t3@gi@z$SRMN#D.|`%G",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "gfHNujh6_E/)T6ThL^x(",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "~xOM8O-82%du`H`1zloy",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "wRuS/.S1KF[sG+NE:!CH",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "B3lH%xilQ!yxbneOxEoj",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "/0rSG(j-aC8T,-ujd~Y=",
      "name": "@Skill/Variable/05"
    },
    {
      "id": ";5z/]GdZHldp~Tr^|TwT",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "|U~Wt+/_q=W%JH-rJ{.O",
      "name": "@Skill/Variable/07"
    },
    {
      "id": ";$Ep[e~E)Fa!La[FR_JJ",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "ALQqgbE7G6I2s]H9.mt9",
      "name": "@Skill/Variable/09"
    },
    {
      "id": ".bQ$^WuP7:%RCoIU!L2[",
      "name": "@Skill/Variable/10"
    }
  ]
}