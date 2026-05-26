{
  "blocks": {
    "blocks": [
      {
        "extraState": {
          "hasElse": true
        },
        "id": ")wA,QoWR/l!.S$qH]Wy_",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "THIS": true,
                "VAR": "buffVariable:Enabled"
              },
              "id": "(;+/Z[?jiBLTlJkaDt(k",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "BOOL": "FALSE"
                    },
                    "id": "x[wj/YI[tOG)a3TW?Q]A",
                    "type": "logic_boolean"
                  }
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
              "id": "03Axz95W}pc?2)+be`M_",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "BOOL": "TRUE"
                    },
                    "id": "JqvpH}_DuiRWYAriz*:/",
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
                  "id": "pdCRQci]Z$(|(7IRv|Qf",
                  "inputs": {
                    "VALUE": {
                      "block": {
                        "fields": {
                          "THIS": true,
                          "VAR": "unitVariable:TotalSpawnItemCount"
                        },
                        "id": "Qbuc[c0kCJPTmtJU+ooj",
                        "type": "variables_get_reserved"
                      }
                    }
                  },
                  "type": "variables_set_reserved"
                }
              },
              "type": "variables_set_reserved"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "EQ"
              },
              "id": "le*7:!^Z!L!5Pqh}D[u%",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "unitVariable:TotalSpawnItemCount"
                    },
                    "id": "Is[(`wUO=JX(ap1Qu!3U",
                    "type": "variables_get_reserved"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "`ATER~u,KXggyp;AX4-/",
                    "type": "math_number"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": -995,
        "y": -925
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Buff_SellInreaseCD_Update",
    "period": "15",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": "L0FGxgv)Pw09]iUHp2;s",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "S.1)JUo`3O6A(l`7?1lp",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "zNdQe,D;z9W~RXGdd}M/",
      "name": "Unit/Time01"
    },
    {
      "id": "XFeW}reg@/g^!@k39Q?F",
      "name": "Unit/Time02"
    },
    {
      "id": "4|/!%0%J[Um}GcfgU%oR",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "CI`Nv{{h-`}`]0W]9TO3",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "5NcULk8,-_!O*2Avv~j-",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "9lE|qh@cztLQdx_2in1E",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "w9n6Wktv5sm8c]4MSe{t",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "b$8Z([T~TqD#36b_S2P0",
      "name": "Unit/Tick"
    },
    {
      "id": "rw*!%c3,WnrKd9g7Or4@",
      "name": "Unit/Rome"
    },
    {
      "id": "xPMdwop!obewIHV)9w3f",
      "name": "@Unit/Delay"
    },
    {
      "id": "58XQyB.yIBEQKdFGdH:2",
      "name": "@Unit/Range01"
    },
    {
      "id": ")ObK{@YXZ4L1op=f?*eF",
      "name": "@Unit/Range02"
    },
    {
      "id": "h}`Pc3L6`4vB1~P|;qb%",
      "name": "@Unit/Range03"
    },
    {
      "id": "T8w~3lK)*1Ex?(0Ryuds",
      "name": "@Unit/Range04"
    },
    {
      "id": "c9{15XnX@RY#2y{[!M{A",
      "name": "@Unit/Range05"
    },
    {
      "id": "|o{PG}Bh62Xurw$z$%QJ",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": ";bTN;C1PPTouoD2c?Tm!",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "=VBmeSLH-E]is[1IpuNL",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "`}:FJ5{/kl=hY:ucM2M-",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "mdg6xO.jGpbQQzDYZ)55",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "~cJ8L`N0/+erKo$-lrOk",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "sCh~N.?!(.`@V402C]$u",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "+3mX(jjN6K!zo8dM;sg2",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "lEh1O:NWYCrn[5%U+cT{",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "^?OLnLueiBY+x)R-=O0O",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "u.y_ylc+pDVdJTV-z}lc",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "-lKpRa/vrmq!Wdwb_A3l",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "DD;=:V`Xn1l^nm-vebqy",
      "name": "@Map/Variable01"
    },
    {
      "id": "2Y;(@T1!e-Am}OV.Nwwm",
      "name": "@Map/Variable02"
    },
    {
      "id": "fpFuRib_!pTf5vNV+7Cl",
      "name": "@Map/Variable03"
    },
    {
      "id": "@#O=th^*62kUrTd|!IU[",
      "name": "@Map/Variable04"
    },
    {
      "id": "Y+;#iY!f**esF)|vn7==",
      "name": "@Map/Variable05"
    },
    {
      "id": "F4KzXQ(F,GNw73EW-gEG",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "^oIdysrx{-L3,sm]lj6Z",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "D=]i?LhK(ao#S?Y`_glo",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "2Q1[RMg9bpJ**KFOL.sc",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "QxS_6L@7X0(u0=1MCj-3",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "[}0[cm|4L)b6Bx@2Bj{o",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "i.|6$7R}yO/S!+Zf;__N",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "`!B=jvf6de(j]EJc;xsh",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "tu-YJD2*?eRF0QBo=ViK",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": "mMyyJ,FQK7q6yaur#,Oa",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": "lyX0=p?{hWrhJkCh:z$x",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "9yLNc8^uUH@k-EjAceLJ",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "Jxy)8|!w.*AX_S_m%ajI",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "SR.9-Aq}gCj@BI)_KcY?",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "Ifu8$U{ewsnjbU~rRY=7",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "9c}ItP(!DtX:8Ov$NP@?",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "L]]dP@#4a)$W)2_T%ct%",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "m]d_6Wd#p+7[*w#X!R;i",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "1$t8`__sKa3V0/~}^Z)W",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "@_#!$c?4G)SM,slT:tFq",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "7__z=LjW/N%5Y=E#UdHb",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "#b)q7!mSSbbvXB[XGP*6",
      "name": "Map/BattleValue"
    },
    {
      "id": "+K@Xbb0}:7)@6mbBn)N.",
      "name": "Map/IsClear"
    },
    {
      "id": "HU3QNfyQs3-g9GsH^8L2",
      "name": "Map/WaveCount"
    },
    {
      "id": "owYWr5cU}k/v4a.bYipO",
      "name": "Map/WaveTick"
    },
    {
      "id": "S*XJ`gTN2tVa=hey_g6R",
      "name": "Map/IsSpawn"
    },
    {
      "id": "N)X5+0=]!O~VXkv.;Zj9",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "Pk]}we?q.q%m:dS(ZUZv",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "IyzW.LTp;!U_2|MX1}6)",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "*gc#mIJDaHpW~d1E}[Of",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "!2/~ONGxf[r=v=(xU,@3",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "gF[K9I,)t(8xr^6UyHs,",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "|*L{r;O$_XyTiR-/Hbe.",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "{|ZtJb8$KFMpP!P_U9QL",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "G~5#kO3xdCc2|Nt6rQoj",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "gtQ;!tmCx.QX`If5,?l8",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "1:{rQ?s%u:{[lLrkFlc)",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "/:IpvC[,35xeKNs*=XN.",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "!%EmkWg-P[C7~{)BI.LD",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "nQ.A/@CA`;E|TgN5ZITj",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "KJ)`da%li1VWP:l%81fi",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "!=OvqjEJeeN2{qPl@I(@",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "J.14]J)k=wiu+vB^A#=F",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "Wi5.%PQ6ZNlC_s,kKwEa",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "ZqKrgi^Zm]vd)SE###h6",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "B`8Y/hLBQ(%#*{FfC7#H",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "^NVI;|.Uk@{NXXSJM?Mq",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "}v8Ln$Sa;v.Gxk[b.m/i",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "b}k#Z)/t)%o$R/BIWEep",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "(.4hqZjb)?ao7,?e,W)Q",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "RM1=[0,tZr5wQoG3v?:$",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "+7Aso8+8AI),,jRR7h]c",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "aoR~G:;^]fl,ymTcij`K",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "Bkc]tFohsik$#|?B=#Bl",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "1rVU+Y=*LI5p@s0(oVMD",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "lEqR67t$V+R[zxnkW$zs",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "`%EZ(#YV%=8(@oB)+NOh",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "[.y1io0kxsSfmq*YXbq#",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "~odp6,4:0uae00/V:bI(",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "*tT%}TBlS]=GrWA*#ExP",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "Dr.-I)xl+TRz5OLBUV?Y",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "RG54,5+z8(`fxeUbG};%",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "UGv4u}txL~,YVXLy^pkz",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "I)p$^:+30a?t%W*?TZok",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "=ZLqe[#C*;S3?xp.F;C@",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "hRIT967a;}4^H_V*w05~",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "sNK6ga?|*U@zEFa;MS*o",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "8-apa$[}/x?Y@[EkP*~#",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "p5V$kjJ)/6]PymYQ3?IW",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": ")Q8I25[].R^KoTQC^?I-",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "R!wTdYPhgyNv1qk[IG6C",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "U)1[Xy5d7*xJq,Z+;3l2",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "mhgiG.JlW=Fe?.*V^mnW",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "`tY]xXn|x^jiL5+Bywq3",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "n6E{arol#`)uU^~lXqv7",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "bIj_FAAF.{9%N1U,dC;D",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": ";yH-FBjz`fN,n1[XS~OR",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "3Rq9/TKw*9,QDn-xcV_^",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "(,s[$[6d,](hTr2yNL;;",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "DsNG|={Uxqk2PHn3FS0-",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "ze|BD/|T#a=G(kH0audZ",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "~9Bfvcy[HyDcWnMBKSHy",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "Q:82-a(u3k4IKr#,;HiB",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "gCG%?iDy;aQEp{fWwYr}",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "{,:*s)3}q|UXu,iUB0|k",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "pfih]|S7l8$-qO4Lb9J]",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "X+t9O|TsAC4(L2+FYWvO",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "6!:Rr;^_/d%-x?!ANydI",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "TsYtx|gIf(~`=FWYz8j.",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": ")D0bkojTkWieVOQ4Z]~F",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "XMfp.}9a9i7HIYDgmbu{",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "]n*6y~v2Z.HXUuR,`k)%",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "^0N`5@K1u`mLKO0o}SW`",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "A6jhxk(18+Sv]:Q:S/Hs",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "SHGaNlOBY$i}VKK%Z;|J",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "7U1[GQ`XB0YPR+|[z3J[",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "3ZI2uxkmY^!LmoFZA.VV",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "}})9z]82/L06KkUKr]j}",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "=,i@l;zXK6]U%(N$a!zY",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "hp=Ys/Zgj59D3Dobm.[P",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "A]Gp(#F;nh1@:8DspJI$",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "dT_i4*+vu+I$5luFGY|.",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "hI[G=XY:9%1:;$F^Y|67",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "O?=@euji;6mO0L#Sf`Gh",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "RL3i$/yod{UI1+TOxA5l",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "?Xuzn*AEF0QehxcZ$-l2",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "QZW`kB;xzbfH@Ui~E[`i",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "c{D[DtKuOl3YGk1zBSSr",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "Ro_sjQ6U[,nwOuxQKt*[",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "/|gGD]Btf(l9EdSwhw=+",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": ")n*Z^j`}vW}f2oHNXvES",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "GYc!5JlPpiPKU}rPX1M:",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "b0J}I{L/oYBC:A]sE{ar",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "WQ6|YusK0%0@26P[gxhn",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "]~d.3m/:c.87`1:ez7-P",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "S;8cF)tr~3)TvB#5|rp;",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "kqMJ*LLgnQ|:a})O|mIt",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "HppJc=|XnT{Zy}]GoZN(",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "kCPsz0H8KId=oKN6G|MF",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "G,oBymLxJ@h7z/GICW{a",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "]]koNx+=)c{X-6r=d$mG",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "$Ty3$7:~VL[Nyqlzk~JY",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "a7#C=eSvt-!0[+3?K}/n",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "-nH_Znu/vV$to_[WFUgz",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "d(C6[7!5,Fuc}==71FKh",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "4-v:n+Q-JHk^*oWK6.jn",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": ".!|Kwr5bhLsMq8oIWqRB",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "YJplJ_|eS%#51,pr^/$+",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "|W/UFY5_wVV[nREU]l_9",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "5U:YGRf@AX[m90qPNl]T",
      "name": "Gem"
    },
    {
      "id": "YivCbqz=hm63(365@!ZJ",
      "name": "@Unit/Variable01"
    },
    {
      "id": ":Qa|o#F4uEb%cY-4ie8S",
      "name": "@Unit/Variable02"
    },
    {
      "id": "~?T7Xv.G|L+I4i)Vdcor",
      "name": "@Unit/Variable03"
    },
    {
      "id": "!l6T.nK_7?Vx]n%,:F`-",
      "name": "@Unit/Variable04"
    },
    {
      "id": "epP-oo9,}:/+I`+EGgEd",
      "name": "@Unit/Variable05"
    },
    {
      "id": "t?(d5%S^jyU^!X:`Ap2(",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "7|]|1IaxS(#sd5p*Ya20",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "oHjIzK1Qpd.KO,6q,/@{",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "n:sy(*`)$=AHFMPVMXsa",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "T1EZ+%!h:$G(X8U/YE;Z",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "Nb~73PHDop31$nz`3=I;",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "6[LJc/ND;TBQ9n#|67|R",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "zo6t_pS]%M[dye0^)fsu",
      "name": "Map/Wave"
    },
    {
      "id": "3t4(?Y$;W!BcELYCquLs",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "itAU(52_Yp:^A5cn[0Qr",
      "name": "Map/Wave/Step"
    },
    {
      "id": "rCZpbNe=4@KE{ewM)|)p",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "{qC,JsKk.:-#97gp.HR-",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "]uo6+_6M(aoos_fyUt6O",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "Hvw?7esLNmA[!lL@xseW",
      "name": "Map/Wave/State"
    },
    {
      "id": "=i|XSh7*zxCoD2+Hr#G~",
      "name": "Map/Player/Moving"
    },
    {
      "id": "NOjl~Z0uc88SDN#_ST.0",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "f?O-9??[=2av@ozArD#V",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "jWx(){KV^R`E;~`/(Vn?",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "u%ZJfTvD$KZL|aGFZ`6d",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "pojycD-e,ua~Z/hr@wx#",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "j7cd~04-h|OfOG5ESzy#",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "@oC/Qd!UKkd~UVUhYY8x",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "}bG$(y9CK/Yo3oLn:$CM",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "c9*y/0yXiW,QeM6F(p6.",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "8vR1r$^@M2R$6;fEDz%{",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": ")%~N4ySF^Dnh^=rxj?FG",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "|](Uj6n?C?;{_-!l/Xy}",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "Gz|j+U]h.yAC61)m+p.,",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "X24oTJC#{0}!(}zjI4a(",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "mwL!Ne1~q*484Y.%+?j5",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "|OQ`]vWr3r9JVY)+}BrC",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "(d$o9EpgVk1f[7EIe~MI",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "49m(9zE-gr;C0Sp,3||K",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "YAE!oSu(pRNw?}(_;2:o",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "0Q-K9oL-)*^VTR01`)}g",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "tOOAgG;Vxl(H-;~5IVtl",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "e(T]@8H_Z(f8-1sfVJK!",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "*@uwH@-)efo14@b(0|f|",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "ayM7d/~Jhm,LQQpyC^^T",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "SL9J,-[r^Qivo0q!+`;l",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "07xt8`ZNpJSKL]_T5VNt",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "m2`z#!)C_03}Yw}$6J0:",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "rB81c4]6E?/faOZ8-q^0",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "tQ^QiEkW:`wYce5E%P29",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "G)N]eJ:DF0Di.R6,uOoX",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "V,8DWcMv*d,(IV/n?H8~",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "jDlpBM_An,ioSUhJ.r`h",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "bE6O:yk2Ksj=O-B,}*jj",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "nc~QPSOCBMCGfP%IdCWC",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "n!dgTLfpkC95s(MUzjUv",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "oH3+/LHdKYn5xfDvE(D:",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "_c:!8n^,m_@znaJ)Q]__",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "eK:=8WzSnK--=`E}$[Y5",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "HMwdyQ:02/8/WFPRP|*G",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": ")wzhx^`0z~;Y4KC`OY/g",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "Z8[,;}/!(|X?k1Av{Bt5",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "c+f*qkyj}j_#Sto8z}Ia",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "6M:n}EydqIYe#P9K-.(c",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "joAAH$+z$lO6rn(P.n%h",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": ",c^87%wA-x:hqn#}=8{W",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "!-lSQ`xsP-nNaA1|G)yo",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "I1deW5,HiPyzm+yAtGkM",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "f/SsUN!WZx$?AG-RuKt1",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "x}2)bewb?n~]vO/n.8O?",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "/ah(XiN{@c;oA(i-*s?z",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "GdDKf]!Zr}c(+h.Ko:gL",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "^wKe4)sE/!]D1JB%w9u5",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "CvT3Pxyu,0$QpYNLOa#A",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "@5.2Q^-Bxcje.m:MxAX3",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "z[`Fk:6wa]bIoAa;v65c",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "VF$vb8!$3xbw?w=olJ^J",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "{7$1r1IbN%VP1vo^K=28",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "s@w14yp[U.y~rex6iihx",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "QpzG*%K4*lEIo$FTBw3W",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "I@73GlV^#LbEd(lgoukL",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "n%*[1|Z9m)K|5)s^JfZO",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "-si=+]QMeZ-@j.V(uF.g",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}