{
  "blocks": {
    "blocks": [
      {
        "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Exp Count&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
        "fields": {
          "NAME": "unitMethod:IncreaseExp",
          "THIS": true
        },
        "id": "mG4SFU5vrwr8YXRArmS^",
        "inputs": {
          "ARG0": {
            "block": {
              "extraState": "<mutation></mutation>",
              "fields": {
                "TYPE": "caller",
                "VAR": {
                  "id": "4Mxm+84[Q/Kj.iWlWtAr"
                }
              },
              "id": "e#Lp%A31=xq^(.Shpd[z",
              "type": "variables_get"
            }
          }
        },
        "next": {
          "block": {
            "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;name&quot;:&quot;PositionX&quot;},{&quot;name&quot;:&quot;PositionY&quot;},{&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
            "fields": {
              "NAME": "unitMethod:PlayFxEvent",
              "THIS": true
            },
            "id": ")]*y?klc:X8bD:9BT;-4",
            "inputs": {
              "ARG2": {
                "block": {
                  "extraState": "<mutation></mutation>",
                  "fields": {
                    "TYPE": "caller",
                    "VAR": {
                      "id": "4Mxm+84[Q/Kj.iWlWtAr"
                    }
                  },
                  "id": "Lfe|Z?;}CIi(f]jsZV.r",
                  "type": "variables_get"
                }
              },
              "TEXT": {
                "block": {
                  "fields": {
                    "TEXT": "OnAddExp"
                  },
                  "id": "0*UX]qzB;wRCuB!rtk;G",
                  "type": "fxeventdispatch_get"
                }
              }
            },
            "type": "function_call_with_arguments"
          }
        },
        "type": "function_call",
        "x": 365,
        "y": 35
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_IncreaseExp_Destroy",
    "period": "0",
    "triggerType": "5"
  },
  "scroll": {},
  "variables": [
    {
      "id": "}FlL:;vZoeF]pnv2@tL8",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "fbpnWj`B7b)u(5-gLa.b",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "od6eS9uSSyWy/a#L;:N$",
      "name": "Unit/Time01"
    },
    {
      "id": "W8]%M4jDnqINwE5ZGw;H",
      "name": "Unit/Time02"
    },
    {
      "id": "b-qMG![m+nr}GxWrC[5O",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "fn0J]K`S!z=NNpc$3:3K",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "L1w6_!fL`r$A31378Jjt",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "/+0hJ?byC}OeZv[j+X8{",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "aT}LKB_W7dk@c9-bZyd=",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "63xdY[X-vWwFVur4immA",
      "name": "Unit/Tick"
    },
    {
      "id": "UN5rn)7=Y:+A`cO]-KQ[",
      "name": "Unit/Rome"
    },
    {
      "id": "PwixQ(TKv1,]DvWQ7RtX",
      "name": "@Unit/Delay"
    },
    {
      "id": "HHRX[IlA{@jzjO,t~R-z",
      "name": "@Unit/Range01"
    },
    {
      "id": "CM02Qh{LZcN|N|tCSMl$",
      "name": "@Unit/Range02"
    },
    {
      "id": "xPy=^KuADX$IA2bayM3N",
      "name": "@Unit/Range03"
    },
    {
      "id": "lJE[r1BE{/M7_6job%pU",
      "name": "@Unit/Range04"
    },
    {
      "id": "Pop9,g6_FKfLoJfkL-lm",
      "name": "@Unit/Range05"
    },
    {
      "id": "fsGll80vmp*Cqk^?7Cgv",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "`*dG(Batz0I[0mFXoRNa",
      "name": "@Unit/Variable01"
    },
    {
      "id": "tXl^XW7X?$7OM%yF+D,U",
      "name": "@Unit/Variable02"
    },
    {
      "id": "d@?r8Af|oqYJ3~RCoO:U",
      "name": "@Unit/Variable03"
    },
    {
      "id": "-{{eyi5HimVOmwqYq3|g",
      "name": "@Unit/Variable04"
    },
    {
      "id": "~R8aND?zFvS[~aV0Ic+:",
      "name": "@Unit/Variable05"
    },
    {
      "id": "a@8Ib}uDm(V6|g(,h@Wb",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "2rUir=+3Gi8I?91_UZH_",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": ";hRQh;x3-U0u;Or7cf8`",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "(Wf_d]=Bjp+%qp]T^SR]",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "H}=j-jQgE$CN%PM-Rk~k",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "#b*Qdso^Mh/N4HR?-)OQ",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "-CygPLQJ$6D{b~?$*Vv?",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": ".Ibm9gT=jkg9t]{5Sj.9",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "R8A+gQb,O;{.BsB}nstA",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "pbcV|Vk}_Cs9K-Q=YHz2",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "L7U*}!FaHK}r9mAi1DXx",
      "name": "@Map/Variable01"
    },
    {
      "id": "+Y(,j^XV486i9FpB963D",
      "name": "@Map/Variable02"
    },
    {
      "id": "2`O:1(*,eP:p-Z4q!A8S",
      "name": "@Map/Variable03"
    },
    {
      "id": "K#9[rV}8EN.YO9U$A!A-",
      "name": "@Map/Variable04"
    },
    {
      "id": ",Mqyb/,xW5Wv_^Y%7CE_",
      "name": "@Map/Variable05"
    },
    {
      "id": "YIq)n$v:W3%)xeqo*(#h",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "!;HUPSKaEIbDQz9tw{jC",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "YHzIyH0oo~jE6D-iwGvb",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "NbSYU9d}Uqg|+[mLF-m@",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "JCSIQ=qvuLMg4=vW6L5X",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "uI-e+|+N|BqiVLB?dZNB",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "jEKc/e{JVD`Hqn[Qi45u",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "r|RKd[FfvsEFrzZO,tXk",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "N~s#WTJhStqDFpPC1kr6",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "eQ-/XM:DgcE6Fn0SVQa6",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "Kf7)4u8OuwAycXLH#CR+",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "5c=5pe3kM-{gu@1%_!|W",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "E_R{)SdN^:}^a4;[?kt#",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "92oL[XSVXXL@ZO[E=NU%",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "KCH`way!`Bkgc)t68alP",
      "name": "Map/BattleValue"
    },
    {
      "id": "ztMa@Qi%4py@(~w}ZvT5",
      "name": "Map/IsClear"
    },
    {
      "id": "}RzW)*zLb9.=|*IxZo%[",
      "name": "Map/WaveCount"
    },
    {
      "id": "tdI$L{zM*UNVWM_$[uHL",
      "name": "Map/WaveTick"
    },
    {
      "id": "3Dtsksw)MYf$b]$iq9%.",
      "name": "Map/IsSpawn"
    },
    {
      "id": "Je_OEu:/E4qU|j^N!XoK",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "_WAOYmH6BhZhvU+7^{xv",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "b_vW2O)Rrs5p(_ZbKea+",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "l*%g;nE/D!@Zr=[mi/~L",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "Qv$t/!8rQwjTO,-jpePp",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "*AG^1ntlu)N=is=x8xy5",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "S!hd2R2nD*G=2l$`{(7^",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "K~$=[3`go@py29=^_/YV",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "W[55WF(mJ(o%$7,mroxg",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "Q#)#}bCn)`0+A^2eCief",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "UtWIxL$:T~1M1u27cbf`",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "VP45.FlAJ^rj^`W$;?SN",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "w|8BWM$d!xhk[0gk%RN@",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "Gcl]vC[Ttfq^|U2tx2;I",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "zU/Ade?grA1Rv(Enp_1t",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": ")v|o#v,M#gzf/nf2:u12",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "_:)Dy,yXaNso/?0OKBg[",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "K?j%gJ+;#yjSY:!`0h[c",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "4Mxm+84[Q/Kj.iWlWtAr",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "ts(^@THOreO%~Gup4$u2",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "HyWq$y^]T*o82jhyxy6;",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "V)|(($BU4*M5O$vD]k8Q",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "fSD4mh/62z/#|(a?YH^n",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "0i@;^r,q@Ul?N2~,2LJK",
      "name": "@Skill/Trait/BlastIncreaseKBPercent"
    },
    {
      "id": "x.i#[r3)cZiG)IgPP}YQ",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "X:Dz(PJoo6D{3{g7M4p)",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "puhd{LUqmPW~]z76S[3P",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "r9giiRw0O(S%C[gh|ZLk",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "dxo;*+Bw?lQL/OU1[u1F",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "r0YSfT.QwnjUe,|W.?DB",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "fm~cJVh_M][vVkz2|bsc",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "8dEtDO.02YTsviAA/2,*",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "SwUu:[%:xu+p[kV929[p",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "x#cLFp`(nh:{*;IY|MlX",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "h*VkA{ocugNBs;.01ThK",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "JOt}LyZV(a5xYI4FKsKs",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "9%Qr`Jn*^_[V3FNm1W.I",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": ":{~MuUc-/=@-dG}RGjRR",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "pARu*(N}*2x:%4s/b1@O",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "9D_[azI;UPM~ZN#1d9]g",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "i`h@MaixwJD6OU?T{B93",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "o{((5@9x9glQ(2w9fYPi",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "e(=0mG|uvaU!ERpqG7D]",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "#*Y*O,.HZ6[VF!]~MCL?",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "[}Q[Df`|#QyJCReDX(0b",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "!G}00W8]d}oU*dB2j#@[",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "GsjD[[fOng!]FxYh?!+j",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "Rmb]b#kTUb7$-fWjqo!e",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "NQXc20M/s`@K6!^G)IfA",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "R45RQ)?vp-1~ko13r/+,",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "hg6=GY22]#{l9PEv95ho",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "JQc;t9Hxf3ynL`jHcW^$",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "dwq*EuH=,D*q.5fy#U[*",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "Fufy]HB4]xn4S`;FDTlK",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "?_[)C3q?5soanMTF]C{X",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": ":8oyG[-KO7ZSYNp.QEne",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "z0*=$2C6#y2?V_;`KNBl",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "yt`FfgKN}SB8XnVzp:*I",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "rYqBKjft^PB@+iaUg0Lv",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "DRtlpi96s.4RQN/P89KC",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "e/9~E[?FDw,v~!V!v7$D",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "@re)MRW:.8$KjWurvfHt",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": ".(}cO*Ky92B*#Y[i966k",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "7Re*xER+Qw,MCAZ={XtK",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "9|K}w-XzSX0pkjZ|nIn6",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "2,CVg:8Z^oZb^)55v]eJ",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "U^=1Kv;~;+$Sjg$t3Bhr",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "LKKr+]I0c6(*1^VQA.wP",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "n*H?D}.N+27oOtV[0#G$",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "|C@@!w-Z5|q!_hdXK5JF",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "lDHR_8+iL%5/+u{zDlXk",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "]{E6b:S[v*hgFlCCbT:b",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "1xG-+d]vHcO%=J!$/_u]",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "Uh@O1/ff*s|0`=5r]rhA",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "UR|C+g$Kr.%s0b*2PnN{",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "lw7=hi.j*5~-swS.1G-h",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "pc;9[|KNe_9VBq[Ncmcp",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "F1~)VmnvT6Pa5o!86fT-",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "}{2f_,xV-FgL!hL$z7sB",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": "-Ie1_gtOGEeIb_y/S81j",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "r#.v/_CjPQITH:g*ZUs}",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "D}nT$#H(#Q8,5^WOv[+8",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "/+-uDm7_G5qnd=4PhMtD",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": ";4wNTS30X1c{t{`DL1O,",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": ":L7O-F`-+3rkX1f4=Z@a",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "TDib_q);bI?gpBs!}i@g",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "8WIy1C0V5NSFFmQX8`4*",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "/hrP5=S,2/W)d$W7gxoK",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "Ro^Y@d~DVy8Ki=4Gn=4_",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": ")pP$QGOa*buiLqe;xAx#",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "h8vrJEp/e#jT*U5jIM53",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "1-]B~S,mFQ[saTzO7E0J",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "7n]P$d,nPmv7cm@IjaS,",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "|,OeG6o0V]6F:+%QB=ZY",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "X`u4+`5hduHQ?b!@`K,!",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "J2mp8+PFbh^l*^Qga7$n",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "GY/$f|;~f#IDd~zaa?J-",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "Vet;qNEz7LugTnIddNAz",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "k0e|Awo!D.5!bSdZ)*.y",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "6$NUx8:^P{3,+KLd@9Z@",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "A|JEP6$`I7.^MLnwZz*E",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "?VQlMI{P(qQ.FA2hNjRa",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "i35QJ--7o.ThFdYtS],S",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "b^(j.1`nFXSzLC4*XiId",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "/`ZW0_Dy67Tj6e2!_eA#",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "8:l][Sk}wKy}P{rJljL}",
      "name": "Gem shops"
    },
    {
      "id": "R~UG~ZdZ}Qi?eTGU1P~7",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "1(lGW/]0f?=y7xaNi[19",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "rd2hzie=/zbhl7ow.}4R",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "$Nk`vp$mKiQpMIWG]lKB",
      "name": "Map/Wave"
    },
    {
      "id": "V$L|zaIyc0?^%#Tb^kSc",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "/Bvy2uvZX`y,YQ0NA.?p",
      "name": "Map/Wave/Step"
    },
    {
      "id": "VyjzYMZ_IE}qr*_}W.:]",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "INv_!}1!aP_6lvR`gw%k",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "_(E5^K*S3Yj#*?`?%|-j",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "Nl5|=QREM9|?=323GI(F",
      "name": "Map/Wave/State"
    },
    {
      "id": "rF}iJNAABr=}w6Eq4gz4",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "_JV0!@6Ug*zq~?Sdu`gs",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "s~/kWJI$)0_bu@n5i`oY",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": ";+VmDakp=ZB(%qLGZF(,",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "eGmW5p4va~qAa-VF*`R!",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "DP?q+Z^Qd7sKh2!^_Vgu",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "v/6~ER]Av=CDXZ_Y:IVu",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "ts5$)eW1vs-t#KaBczWX",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "a}h(YD%S8T#ALM?~gW;B",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "mqf)A:Ww7Abj#FsbM%#j",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "sO}XSUM--zUJl$JRtuQq",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "E-%RJaJ?WQ7;.DoqbDb.",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "k.F|(u!(-ej:^t-{3*,=",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "CW}ipOGNBlCzP**E[;-s",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "T0THEs2Kw}y/v8.kaT]i",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "^2X`j/a;dikB+cTh]P(0",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "nL~PAmI1lbAl0dQ#dRJP",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "t`t8t?Mk:077.#UF*VzT",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "Ldx0*^dGPf0|#JNbWqe6",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "S=f!b9^XuqYE-Dt!.x:4",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "]WNbrrm@~o[2.VRR}LyN",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "VE]w{g0[#qO(G[vyUO%F",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "XA/)8~W;U3V[kqsNE8`J",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": ":`kQqvd7/U8og%_UD#Dc",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "qpUUcLJ^^$~07]U%`HS=",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "4d^Xo/dmC@`K?q}nrzd7",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "FFL(Q6y@WnD^V72RR9Da",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "_iEDWU*+dv@t`+u~Wu6c",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "{!`La5Bi=,/UOH/Lt[6U",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "49QS-qfNe7Qfv[U;(uvR",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "xOJAwsA{VRGso;QA:@y4",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "^s{pAONz]!c^pS$u]mCD",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "JRy:-AE-aK5Gb4W)1Tm#",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": ";m27+ybKw~tQ_l}O]!T4",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "{Bfb*1V#gi!p,Qg@=f.L",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": ":86S?,+P}v^;KjGlcL~~",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "HmGE%|xshLVz^$sfMBud",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "SSikpEt#Ms^sH+Reo2nn",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "4Y;Bw/_`kUt#|uD,VnY+",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "RxQgl-{xY9{UR9;m;b^r",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "Rro~)lrw2D~6Q?#$SrkM",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "Vr,@S{h@p:zgvs](HmYN",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "Rpl/B`c0,%.4gT!xSj0?",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "3uQxI#;=AHl4}VP#R@G_",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "dLR$oK}xfbNvGH~6H%R=",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "xY7%M%fjLppO9vVEAEW)",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "Z0,X]F$.Hp^i$!P*JDBr",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "5q%[{lq8Y~M}jy2G.Bx,",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "2FdB:s[m@@w*0!NzYaFJ",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "5HG]V8b|Iiwpo9rXV{YR",
      "name": "@Map/Wave5/Monster10"
    }
  ]
}