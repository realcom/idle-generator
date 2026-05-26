{
  "blocks": {
    "blocks": [
      {
        "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;item Data Id 입력&quot;,&quot;name&quot;:&quot;ItemDataId&quot;},{&quot;comment&quot;:&quot;갯수 입력&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
        "fields": {
          "NAME": "unitMethod:AddInventoryItemByItemDataId",
          "THIS": true
        },
        "id": "6Yb`C4JsOuk)aVD.?+;=",
        "inputs": {
          "ARG0": {
            "block": {
              "extraState": "<mutation></mutation>",
              "fields": {
                "TYPE": "caller__skill",
                "VAR": {
                  "id": "Wcwv/qYTpmO}PPTqy^Bo"
                }
              },
              "id": "%g4,N`32J+PN?B!jmc.a",
              "type": "variables_get"
            }
          },
          "ARG1": {
            "block": {
              "extraState": "<mutation></mutation>",
              "fields": {
                "TYPE": "caller__skill",
                "VAR": {
                  "id": "lCNeQq~a}!_LuMCj|Emv"
                }
              },
              "id": "m_^,4B%O|)*]gG6]YFHG",
              "type": "variables_get"
            }
          }
        },
        "type": "function_call",
        "x": -865,
        "y": -205
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_AddInventoryItemByItemDataId_Destroy",
    "period": "0",
    "triggerType": "5"
  },
  "scroll": {},
  "variables": [
    {
      "id": ")pzXZ)Fv#5nO[r5eZX=~",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "jUA6[IuQMCU[;BS7UsiZ",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "/|g0)yz8uS=#CZ2CDJB^",
      "name": "Unit/Time01"
    },
    {
      "id": "9F8;nEPjKdwh^li.%mG/",
      "name": "Unit/Time02"
    },
    {
      "id": "ULFe`-y^01lRz~tHxmnm",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "4]39IEWgwT!iBma?zg1,",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "}6L}#=~(J.Wyubql-#~M",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "pc}{OLH9kGe=F|T[[7xG",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": ":(ug6/I`C{Hg}`L+GV|D",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "6Q#*{YJi=AIjSta3(_hM",
      "name": "Unit/Tick"
    },
    {
      "id": "^gepi^eXp$YJ-7ohg{jP",
      "name": "Unit/Rome"
    },
    {
      "id": "nRj([LOp[ncYBku$$#Ba",
      "name": "@Unit/Delay"
    },
    {
      "id": "s/Tu~c,N=+MAuK#)/oxh",
      "name": "@Unit/Range01"
    },
    {
      "id": "3$BqKmJE5hJ%BtqiD.yd",
      "name": "@Unit/Range02"
    },
    {
      "id": "Cut|#Wt)7jm3d-3i##!)",
      "name": "@Unit/Range03"
    },
    {
      "id": "mFLbLk%%Fp(c(j/8mV]d",
      "name": "@Unit/Range04"
    },
    {
      "id": "$:+.YOtV%!(Bj[l-44c;",
      "name": "@Unit/Range05"
    },
    {
      "id": "b2RZuS#T8*ia|sbvHd0v",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "j-If51!puc6VQx$oRvHv",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "T-UUt*qX(vNa=*4:ffWO",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "GeDEUwN}*g}c@eJ2KQ/1",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "w:NCQp,OsGDmp!62^Del",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "m;qPxa,%C)GGd|1Y6vs]",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "kJF1Hz3)HYWfRhNi)6Bq",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "KHw]~v9DJ!B5{2i`sKCI",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "P(05ybu*+jc-p;_l%|n{",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "j/V.zaD/vbF1,yPPdzvu",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "b76UVwHi@4HR)SZ}s$ZU",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "0Jouf*yd*kQ^N0~n%qxV",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "d;[x.WkVYlmZdla-k1,b",
      "name": "@Map/Variable01"
    },
    {
      "id": "zAe=P=xHBCIv!mVrS41q",
      "name": "@Map/Variable02"
    },
    {
      "id": "FH){K}i.R[NMY/PzkE[8",
      "name": "@Map/Variable03"
    },
    {
      "id": "m~4^;5G6pPE=b+Wuh9O9",
      "name": "@Map/Variable04"
    },
    {
      "id": "(8FrcVYmk`C_:S_O8*Yh",
      "name": "@Map/Variable05"
    },
    {
      "id": ":yMBZTijlbd~8_mJNUj#",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "7yQv=R2s0qM7iQrN[V(+",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "`mb|x2u;*~@Y(cQ=m^6v",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "N.QI;UV4I|21(,L3v|$K",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "ARIXGMI2opewtNB^reln",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "p-S@O{A-.}ticj:Nns(=",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "m(ZRb:rsmaOxH!92e|wx",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "5cqYYo|p8`GlO3`}nqvo",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "n;7aQTq_$7QPWPb6dd4d",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": ":6_;=ZH[=%y$(y1RGIGZ",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": "6Maky`b59@lQsE,;`v_K",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "]~A01itY0VVA]:Kj.:bk",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "S?%=]2qzs94ctg.iZX-5",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "OA%`ixDi8Nod9;/(]ff_",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "EgA.FhNR{#MAqa!PXpu@",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "Y4rjX4+qB=A_.hTZXZ6T",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "G*fq?{_Hui(C}3Ouvv7(",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "%9_YxAh3#(imkiPZI1)H",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "qBB;Vfh+s=YEIP}}u!B0",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "kKxG?E-5W7#@ZrrZemSH",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "TB9Oyx9(!THZ]6/(-G}B",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "T=aj][7IN)4:_fK-$6I.",
      "name": "Map/BattleValue"
    },
    {
      "id": ";kS=No,~7r5RTe*BWTA8",
      "name": "Map/IsClear"
    },
    {
      "id": "NcPigrT561UXu:peNL!~",
      "name": "Map/WaveCount"
    },
    {
      "id": ")t8G;PACK**hkFMt`Ykg",
      "name": "Map/WaveTick"
    },
    {
      "id": "5;!Z}6ezRGR`{qPE^[dP",
      "name": "Map/IsSpawn"
    },
    {
      "id": ":|mKkg4RDE[9Wqk=N$;J",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "IHNC/iV9Y^*`9dM0ge6(",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "|NKs,9G-qX+82XJTHMQX",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "1|`m|QJmPub[w*w/|)DM",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "yHgh__*IuDP}y`[o^5(Y",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "(2uA$W[J5=?Y}9Tnt]OO",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "Pq,UWiF%4XSq/Kh,AxrT",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "ZH9?#-EP;z0*6~5JzD3R",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "JMyv]5C2hbJ^XSl68wYb",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "nqh?c=sf7sop@N3j|DNv",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "`^Izk6]A9Mh9HtdxwKd;",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "N,hA{DyIh$Xq7?URN7ko",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "Rk9=8KWSSYWR![C{%*wt",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "sxF_xhtUfuagCW]=d[WZ",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "OEd(4{s;|muA9jMILbmC",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "HG.=NVb5IX[9+s-oED^*",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "R7:l.3(EQ5B]J^@(BLSC",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "0q%*H/p5rIAl!,]Ui#1K",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "Wcwv/qYTpmO}PPTqy^Bo",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "lCNeQq~a}!_LuMCj|Emv",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "pHSajwR2mIAmPM=`iNc$",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "+rF3xKJbsKu4d#2/Y6OR",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "H*akG[:4%SF)x)8i^QDd",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "5Iox${*/l*jTn4bn+0P,",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": ".vJZ{7P@QWhH/RUs4;%y",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "%q0fG[P{4w-+Y[(,PbNl",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "zGLKJdnL}_5OaB=R{L;F",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": ":+voUm?Ami^~{(P6Y{/p",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "lxGz_B7L06BN~b[cN.di",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "u-KO+R0+SsZF{`)-G_lD",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": "%t],O]OgoW$o:w8ometn",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "Nza(F0OUD+|KX[hd`20v",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "J{MEe=A^%veOcRzh%#Lq",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "f~v]Oi{X~?kh,JTy?pVI",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "oh=bNluq[Bun*/Bd)UpW",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "vv1iKOW)ljLRd}$@iGu%",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "{dN#eXcvk8+Ma9|yKOzF",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "Eo;LRLESbyGINM.`./iu",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "lHbEO{F~yEuNn^2Ov{+y",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "om|l:Oaj!z|XU;.qIvL;",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "_roKL6cD/Ws|cL7QHLA4",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "F4Med?3gT1hb:F-pADJC",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "^9?@6(hhb{8+%H`1nj$S",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "zSk_1#zc]RvAMGxB=XDL",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "{1|kZn0@Y}-g-wrxxL|*",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "^mA|I1tNAtl@$~:BasY.",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "d_)Qr~-rg6V}Ru-Hw/JR",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "=Q-UrK3sm%IiuWdKM;3y",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "_S|??]hk{ldDd@qr00D?",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "Du]n-lCvfaF$/Xn{z:Ce",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "MM4K6n);NB[bVaK})+!r",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "z#0cQNJ6Ff]+X[cjG-Xb",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": ",KPZlEy3IQco3O0TWkvv",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "FWLl6V0LK[--NgbhFNs`",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "q=@$ki)`i0#itMG$:`o.",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "$7Rs3T^zyjLGLjQuCQD6",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "{dwRI4^({jN-jXFDBs=D",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "]*4cVC+[,5?Pi`};Tu0a",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "LO83c,I9oUpSRgW_gKX:",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "cd{*#891!e^r{$0Vppab",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "#;]26?]r/=bjP:gyS!*?",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "u#+[_Ci)Es.mC5})7K/m",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "qW=lip^{*n]JPisEC,f^",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "A4]9*+6KE_T;BR#g]A![",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "jI@+2S5*]q+p*Y9IR1tW",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "]b_/jf([DydQM+I8Hh9D",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "?,7#)|+bF2i!!t!eH]01",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "]Atq7AO)Qrdq}38Q%JIs",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "F5ub[Fcg95-jICu?/]-b",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "|yss-bk?GXN)brC~s/0@",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "hy?qs^vRec59oceQEdPb",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "K{v9{KG}[dAR)dE3B{E)",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "K:4BB/upf`+[0l_Gb~4/",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "Z*)PQk?$l3D1pf5K.8a3",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "H0aQ,bMpFY)gCTgbl_yH",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "$(eGLs,5G]V-i}CDI5K@",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "YV3pmeS_tU-d`5*HOHH;",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "q:{welZl#|Hyi=wuO.sS",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": ";yNLFdMhl9ulHY8{+U}u",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "nCVDLOEb)**@HK^dWQ(H",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "Is*~PYNi:!h,!UfTMxqq",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "D:Z)dsCt#_q3{OQ9[c9x",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "yjfK;Y{0w$V0V_{h_=,g",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "5.O5U0dGZZ}5(xDK?VJ6",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "C~rTbC@GP=AypQ%49ml5",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "hybnf1xt$;P*2rd.$/Tf",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "{FE+o)oC9w.Nn%]uJ,zC",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "hJxvw/b+aO,khn?Od;WM",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "vW(V-._X_6M@rDru6w%Q",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "|K27b|`mAIPaW~sG^uE_",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "3Mf?K`gG}Tps)hk#Ta%.",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "ehJNF*G=5M1NZ{w*a5Av",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "yJG_,Ng1A!NcL`/[n~p-",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "4CF0SkS(g7]rwflWUnbO",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "f+@XH[O74N4]+PvA`fMK",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "HTdGG!vH+q+LjZK%nI2O",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "}Gh,rVzbj?O[L1|:g$P^",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "jD14m;4IeNI|ez-HiyaR",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "*Pk8!%0UD]zW`6B.`k]9",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "J:eE(%w43BuG,lG%$xJv",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": "+KhO}nFqW`RCgDdLEYDd",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "+u_zyTq;F[lSk36v^:4[",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "eGk#f*s9Y_ND_WAA#YdV",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "D,pRmhIsx%v[cI`a_9GR",
      "name": "보석 상점"
    },
    {
      "id": "$`;wcX{1s`Io!T=6Z_ZN",
      "name": "@Unit/Variable01"
    },
    {
      "id": "J:_R)0=X2.2#OIV5y@nj",
      "name": "@Unit/Variable02"
    },
    {
      "id": "aF*,dq*(BzweFM#A975#",
      "name": "@Unit/Variable03"
    },
    {
      "id": "GPpLFXNSPgjf:4=2{Ks;",
      "name": "@Unit/Variable04"
    },
    {
      "id": "-D(ldBDx$W`).j$k)9z!",
      "name": "@Unit/Variable05"
    },
    {
      "id": "U|[,,9F:`W|5I44v_91l",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "l1*c_t1g*LFJLObQ2.!Q",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": ",7WhAQ8GfCxi-m:%{YW:",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "/2`~}mOiJ@P2PH$$D.*0",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "o^y5J#h)6b!x.JU%Z/u@",
      "name": "Map/Wave"
    },
    {
      "id": "cJj}HgRbMZ8a{I?/S{gO",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "L}$^/!KleV)D7}x10tI#",
      "name": "Map/Wave/Step"
    },
    {
      "id": "6Qc!.zmFFX,W^zzg2P]k",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "c:2}9XMej+bC9%y+r0#G",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "jUF-Pe6A1A-ZtZf6)!kM",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "N$4HXNV%lq~M[hvS7Zfe",
      "name": "Map/Wave/State"
    },
    {
      "id": "@e.5QSJ(1_DN1q]UED72",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "qR(u5Wt@zt,bsY[mNd7%",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "d%XQMk6Wv/Q4b]l_1w^[",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "`F]j)7PczT,9s27PiMJx",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "e]wBt4;__mYhsVLT^cA9",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "+etaT$YPV^*g1PF+D^):",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "^cuD+D:VA{V/1%i4mbCc",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "Wm]R~qxiF9Z@UJK0k=;5",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "Nfc#;@x:V@VI^d9j/#38",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "vE(R#e+b:6q}SK8eGRzr",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "T07P1yyLiNeClXFs#;#F",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "aTo[kBe=kJh4hlbfR{:N",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "h75G2isYe!V1uY[QfT|r",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "v=T#eTI~h??{{_X|XQWo",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": ".^B-7Nc,r{^7=0l0Y;Cj",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "!ta/n|pB[fQyqu:_LMpB",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "NSSg/QWg{qX$k#~;+)dV",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "?R8HITZi?^yde@Txbfvf",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "t+vJX)a7N#iM[Y,i~s,3",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "qV[0{f{cX#Tyb*f7Aqj6",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "T~Mw[zE=$,~ew+bFAmJL",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "F$R?_q^%T+H]%HPqa32_",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "Gq+UDiYR~.l__(9T^]MO",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "hafcVqfj=4f+egnGO0dg",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "a*r(dtl-cnLo7nvN-wH[",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "1l~A?e+|I#g|EiQ*sOtk",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "T}~6*PtGiD/h1@fIj[f!",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "UZ:rcCH2=M2JU:?7+zn*",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "xN|S:,M:).R[AAY|5Des",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "1qM7/W/%@osA%T@i268e",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "T^#;Gh5x8RhsXN!+@l6,",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "QD*GfGp*KA]z1)oT{B73",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "[DMur7,-H/mBjyT[ntz/",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "@,qe#ADC*MOFu@=2r8h}",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "gqO@)W(oCJ:!Sa!pCFH!",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "9A:1$_prsqT321h~|hXG",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "Lfyvo+pErE%0W#?Mv~0F",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "ikpHc~$0Rt9e}aHo+)?5",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "fta66FSvdP7}Jj0C7u}z",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "3_6GpkhrW029Osv=8qQu",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "Ca5%Y9y*3=N1Zv0oWZjC",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "R$ic%E+dMIYpINlOln6^",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "D#%I{]A;I8WSlU]k7Sva",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "|sD33i=JE/B=CT~D:oa{",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "{ebwah2RwxGM=7)5!?[r",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "NGDy_Ay=OD_?#g#?wL9w",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "bDB7c]z%TAN%=/JaUem1",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "|@E-imhPQsT;%%Z^r![e",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "7S`Q?t9k0msRS(TZstk8",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "#hhx8(S$*iOl}cMVZm[B",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "s*b{[g*hR}%os,+C-.W4",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "`:RRTr!5*4/JsR7qPvVB",
      "name": "Gem"
    },
    {
      "id": "C@x)@aiy.EVBRLdt/)5(",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "HR.*mW3_YG^J5Wg=TKZg",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "e,m2hKDs11N}2x}C:@ZC",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "oC3UK{.7dT^xFv7k)/{^",
      "name": "Map/Player/Moving"
    },
    {
      "id": "Mi~Vi#s[L+DYC*cjYn30",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": ",VeO3A88J7Ima$v/?v_P",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "H~Zsm-H+]s?x0G$$gQr{",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "C5DNZq:Qdx`]cq|V.o9d",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "kybpUtlgYDbTui1~`{f;",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "D1?ReJmzS$L,FUVye]ym",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "D4c9W2f5`sT0}h1Wb99d",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "BpkVvSLOYBr+1?=_(vbe",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "!Sr`VMaRho`(}L1d-f+;",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "gu0z}dLrUViG;x)%?Ykj",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "RhQ`00Eas3tCSrlaiBfI",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "a|3(Kp)0uH6ZByuuiDnE",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "vyQXE;|P8cD{-c`|jKVo",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "2FuX%UwegtteafH{#z7p",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "x-@B{2HB0*I3mHARJTXX",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "Ro342Q;L|X*W%CnPjIzU",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "vi22MC,rJmQ(mbzssL~*",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "2av?h(2$p9xlPv4HS`p*",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "c+Ko[y;xPQXl0ZEdzsl,",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "MkN`zx~]rK|8kha;r|Ey",
      "name": "@Map/Progress"
    },
    {
      "id": "4XFgQ8%MQnf4:j73H0-i",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "(Rx8r]:/RM*a}Xy2K8:%",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "@X4dln+:H~b.E~}OA2%K",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "8L7zSs@O_%(QNgA,RO|Q",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "T=9)GGR0;a!C`r01Sx=g",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "#=F8Et~mUa[PP*%GW^#O",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "Lt_;r(^yhXKRGZSRBXCt",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "U(C^xDWpfpV+as17Mt}[",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "T~J!0vP9UD9mGZ5N(JAb",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "AhAcKp`t?ZfnI^|7F:YI",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "g_8)l@DF63,J4U}(phGd",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "elqt!_OyhHS./dj.x[Ow",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "T!lfBdFe}S#~8UnF1c5s",
      "name": "Map/DisplayWinningTeam"
    }
  ]
}