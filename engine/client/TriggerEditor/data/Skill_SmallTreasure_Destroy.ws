{
  "blocks": {
    "blocks": [
      {
        "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;item Data Id 입력&quot;,&quot;name&quot;:&quot;ItemDataId&quot;},{&quot;comment&quot;:&quot;갯수 입력&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
        "fields": {
          "NAME": "unitMethod:AddInventoryItemByItemDataId",
          "THIS": true
        },
        "id": "r5h~;eE+f=J)}c;Pxj}m",
        "inputs": {
          "ARG0": {
            "block": {
              "fields": {
                "NUM": 1110001
              },
              "id": "{d5#{Z*//-[sA6d[@8NL",
              "type": "math_number"
            }
          },
          "ARG1": {
            "block": {
              "fields": {
                "NUM": 1
              },
              "id": ".!RSscG,D$74Af_=Fy1M",
              "type": "math_number"
            }
          }
        },
        "type": "function_call",
        "x": -1075,
        "y": -865
      },
      {
        "extraState": "<mutation itemCount=\"4\" metadata=\"[{&quot;comment&quot;:&quot;Weapon Category(-1=random, 0=Normal,1=explosive..)&quot;,&quot;name&quot;:&quot;Category&quot;},{&quot;comment&quot;:&quot;Grade(-1=random)&quot;,&quot;name&quot;:&quot;Grade&quot;},{&quot;comment&quot;:&quot;Rarity(-1=random)&quot;,&quot;name&quot;:&quot;Rarity&quot;},{&quot;comment&quot;:&quot;갯수 입력&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
        "fields": {
          "NAME": "unitMethod:AddInventoryItem2",
          "THIS": true
        },
        "id": "c:qyZ;(5*/}t]m1Xm+ys",
        "inputs": {
          "ARG0": {
            "block": {
              "fields": {
                "NUM": -1
              },
              "id": "5IO#@!hsZ,p$F[Nld@y7",
              "type": "math_number"
            }
          },
          "ARG1": {
            "block": {
              "fields": {
                "NUM": 1
              },
              "id": "1A@z)S?kXx58V.P8F`.C",
              "type": "math_number"
            }
          },
          "ARG2": {
            "block": {
              "fields": {
                "NUM": 2
              },
              "id": "y[`hU_.AM.Mt@HFo@mR;",
              "type": "math_number"
            }
          },
          "ARG3": {
            "block": {
              "fields": {
                "NUM": 1
              },
              "id": "`LCJ.f+Twjwx(k{+C3?8",
              "type": "math_number"
            }
          }
        },
        "type": "function_call",
        "x": -1095,
        "y": -695
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_SmallTreasure_Destroy",
    "period": "0",
    "triggerType": "5"
  },
  "scroll": {},
  "variables": [
    {
      "id": "{6E*vcL,:t@ZQP.SSWX!",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "S*(HsO*n)*EYk1/Tz[aF",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "#1mz,DZUeUj-wF+R3$h5",
      "name": "Unit/Time01"
    },
    {
      "id": "*[jY1?5Ktqp#XQ8#=$=y",
      "name": "Unit/Time02"
    },
    {
      "id": "YgMyJHo}97ms%lCmJcvD",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "PJ+`kY31IVY3Ipo+ucYK",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "+HAH_GjgXdkKL6z.XDEP",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "_vt9h}8ML3[eVQ7WOhD]",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "1HbC_mkAj7i?|MH]CuDx",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "r|#9;ga=4eTR`Ef5|g($",
      "name": "Unit/Tick"
    },
    {
      "id": ")t_A+mYi/RmLRuDKU$9d",
      "name": "Unit/Rome"
    },
    {
      "id": "E1/%8g~r2@K-85^l%B/#",
      "name": "@Unit/Delay"
    },
    {
      "id": "_!*}S:Cs{kr(tV]sh}i4",
      "name": "@Unit/Range01"
    },
    {
      "id": "Kk/cq4+~mV=*dU25BtbC",
      "name": "@Unit/Range02"
    },
    {
      "id": ":fCP,yw78dSal[^%~`))",
      "name": "@Unit/Range03"
    },
    {
      "id": "2uE)A9XtrE$FljLk5cX_",
      "name": "@Unit/Range04"
    },
    {
      "id": "(KJq:02I3!1K4JF`y14@",
      "name": "@Unit/Range05"
    },
    {
      "id": "2miruB*@ajJU#D`4sfy8",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "!h7eGq2byasm8A3|Qq1g",
      "name": "@Unit/AddInitBossBuffID"
    },
    {
      "id": "IO[}PkqBSf;O4B9~/Wr6",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "uyCxz[h]`s%=?o94!3VT",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "/r^J|vjkAaGUg_-}9kqT",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "2}N{)Le_0E,bOH5%YL6O",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "q};}0I{XWpp6wuKPv6=K",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "{8G8AhJ:-@FY),FU3Ee?",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "uBrTmA^n0bD{Gg2#C^js",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "oXr+9Eb{*tIOl`WKg~Wa",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "djR_hb0(m*|Pz;k+O(11",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "bU;%sN|w8R$`2,Cf=8.k",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "t*9JFgiwkKw`n%=NR]wz",
      "name": "@Map/Variable01"
    },
    {
      "id": "m0n3o;Qm|(D-k+uTbpGc",
      "name": "@Map/Variable02"
    },
    {
      "id": "$)!6zluD9DC/|~G4w61r",
      "name": "@Map/Variable03"
    },
    {
      "id": "(*O^fQ5$li2=M8Qe/lnM",
      "name": "@Map/Variable04"
    },
    {
      "id": "#aIak.|`_A5:Ci$qM;-E",
      "name": "@Map/Variable05"
    },
    {
      "id": "!E|AWmiFK!.rk5ww=*~c",
      "name": "@Map/Encounter/Unit1ID"
    },
    {
      "id": "U!@!w8@`nL[koc%6wYu*",
      "name": "@Map/Encounter/Unit2ID"
    },
    {
      "id": "h74QRZ_2;@ZS[KWL_-Mc",
      "name": "@Map/Encounter/Unit3ID"
    },
    {
      "id": "Hc,_1-%p);l}EG)m5yXX",
      "name": "@Map/Encounter/Unit4ID"
    },
    {
      "id": "=%Wd([.D/jbOJOf6EP47",
      "name": "@Map/Encounter/Unit5ID"
    },
    {
      "id": "?8(`L)$b:M*[Q2X.tzBQ",
      "name": "@Map/Encounter/Unit1Percent"
    },
    {
      "id": "gk+H54q]Z+bh]nQbuqdJ",
      "name": "@Map/Encounter/Unit2Percent"
    },
    {
      "id": "5,B0}9?qIs#2HM(cnqCI",
      "name": "@Map/Encounter/Unit3Percent"
    },
    {
      "id": "t8uTIo{~jfFTV`m$1U?[",
      "name": "@Map/Encounter/Unit4Percent"
    },
    {
      "id": "Vy]3sz(7UWCnT3P5keMo",
      "name": "@Map/Encounter/Unit5Percent"
    },
    {
      "id": "Ut*~L#3CBnRZ.Q;oZg*T",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "?;eL1}$@G]d]$6LwgE|0",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "fGd(%|KU``~,z0wGdN*f",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "Y?#tb-NEJ))pen892`WV",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "f/7l:3ppjxyT]+^uAZ@T",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "N0rE#XyG=FV3D6tE4-ts",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "|jQBSoHrq9kqG)%Upy)L",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "1[D{Ii=@_sRJ2V)Kf+y8",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "4.gRJ#MriSfpMAU}OO[#",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "OJ_8sKr)U.1-a`U?22Qo",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "f.5/J8Kr{UEezM$o@,IB",
      "name": "@Map/AddBossBuffID01"
    },
    {
      "id": "_S^OAr4`2qE,~%qcL4ui",
      "name": "Map/BattleValue"
    },
    {
      "id": "1h9@w+3W5P`2P3Bd]7fE",
      "name": "Map/IsClear"
    },
    {
      "id": "$qQ%,#t-{7|$H-sTS@3$",
      "name": "Map/WaveCount"
    },
    {
      "id": "HkxL51Y2W9W_J/KX=x|9",
      "name": "Map/WaveTick"
    },
    {
      "id": "?[pss:_2-[4mo*e9F7Pw",
      "name": "Map/IsSpawn"
    },
    {
      "id": "5v0jjFpj]#^,rE~a70O}",
      "name": "Map/WaveStartTick"
    },
    {
      "id": "hNwH7x:Y@6Ju+ZJKT6/~",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "n,gGDm{sL@LZ(fW?fO2u",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "Q}=a2g),b?n{0sMa$,l!",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "3TE*$F1BY:Ma|EG:+=Iy",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "q1}cBY/;U3zx8;cI-gLd",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "#gH-u}[|UVWq[Yh)HX..",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "fYD/yz`YeA#:#lW!%bDS",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "WKr(tH.1,~I;InQ[nN6v",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "?_--^*kZ|OvOaSU):|tW",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "AB/tdx#GM`EuYjMevv1s",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "v3TzhQX.Z[iP:9d}YyJA",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "-sJ4JPRc{o8:J3XoD[y{",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "k5M4OR[e3+;enaJ|Gs8{",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "5CCLd7X[?LdgZhg-HFHV",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "=dqw`n`:@w+mUP:Dkk#E",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "J.ev#rHS@YR4GQyM;W#x",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "2j:I?T70;=|Px2/#Ewdn",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "p5a2vfY6NlKuv0KZ}|WS",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "PF9XR1%GdX0`f~:O@BF*",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "d$}r2v+.}~}lF0f}?C5_",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "2W/7V5tCKp^0pt-ZV=1^",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "T3BOg_$ks;qvra$Lrh=L",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "zpmX}f0A5#.$cY}!Yu)B",
      "name": "@MAP/WAVE1/MELEE_MONSTER1"
    },
    {
      "id": "pCx$yXI:uZaa{7c}x`kA",
      "name": "@MAP/WAVE1/MELEE_MONSTER2"
    },
    {
      "id": "Sx9C]WmLF9z+:I{,eyf3",
      "name": "@MAP/WAVE1/MELEE_MONSTER3"
    },
    {
      "id": "XjKwMY]S@,PY,81whX1K",
      "name": "@MAP/WAVE1/MELEE_MONSTER4"
    },
    {
      "id": "MQexxrC{pN|kKTP(~BZG",
      "name": "@MAP/WAVE1/MELEE_MONSTER5"
    },
    {
      "id": "T8)DlS3VlNEa}LO]EN4a",
      "name": "@MAP/WAVE2/MELEE_MONSTER1"
    },
    {
      "id": "1uJJc=o6z?%n}-]8-F^,",
      "name": "@MAP/WAVE2/MELEE_MONSTER2"
    },
    {
      "id": ".YYA9#C*@V)KVBDEEL6t",
      "name": "@MAP/WAVE2/MELEE_MONSTER3"
    },
    {
      "id": "/)-A!/CUiov/DU(m+jfM",
      "name": "@MAP/WAVE2/MELEE_MONSTER4"
    },
    {
      "id": "e}U$-P8??pa%71)mS=tR",
      "name": "@MAP/WAVE2/MELEE_MONSTER5"
    },
    {
      "id": "yco:%pxT6bcKB1oD%$%d",
      "name": "@MAP/WAVE3/MELEE_MONSTER1"
    },
    {
      "id": "uI,F,ljaNtGsl{xfu^NC",
      "name": "@MAP/WAVE3/MELEE_MONSTER2"
    },
    {
      "id": "ZN/+08)79*+Pd,K8lTGL",
      "name": "@MAP/WAVE3/MELEE_MONSTER3"
    },
    {
      "id": "O.YpK1juhadGB%Z;PUr4",
      "name": "@MAP/WAVE3/MELEE_MONSTER4"
    },
    {
      "id": "?Z6$i9$n_{ZNOmV%R^p+",
      "name": "@MAP/WAVE3/MELEE_MONSTER5"
    },
    {
      "id": "p0`AVA]Zib+*f|}OqB*L",
      "name": "@MAP/WAVE4/MELEE_MONSTER1"
    },
    {
      "id": "FJZ~YR:`d,7N[HGtAOD$",
      "name": "@MAP/WAVE4/MELEE_MONSTER2"
    },
    {
      "id": "r%=L)vy))Humh=A-7`Nm",
      "name": "@MAP/WAVE4/MELEE_MONSTER3"
    },
    {
      "id": "?#A=|iY;nTsa;n[txta(",
      "name": "@MAP/WAVE4/MELEE_MONSTER4"
    },
    {
      "id": "SR=uASh]F$0VWRak1lWi",
      "name": "@MAP/WAVE4/MELEE_MONSTER5"
    },
    {
      "id": "~|aeF9Dy{p$G^k;+OgW}",
      "name": "@MAP/WAVE1/RANGE_MONSTER1"
    },
    {
      "id": "Cu_D+MPmGy@pWK`tZ7gm",
      "name": "@MAP/WAVE1/RANGE_MONSTER2"
    },
    {
      "id": "(Oqzv`-Gj2|v`Q8/aD?4",
      "name": "@MAP/WAVE1/RANGE_MONSTER3"
    },
    {
      "id": "n)4$Y-.dimS4ZWC*nSd,",
      "name": "@MAP/WAVE1/RANGE_MONSTER4"
    },
    {
      "id": "#~O?e[Ok]SNCwZi.P/#x",
      "name": "@MAP/WAVE1/RANGE_MONSTER5"
    },
    {
      "id": "Vm)g;VW:%A-.~8Sj1CqL",
      "name": "@MAP/WAVE2/RANGE_MONSTER1"
    },
    {
      "id": "L]@j:KL*!dAPUP%)9@yc",
      "name": "@MAP/WAVE2/RANGE_MONSTER2"
    },
    {
      "id": "#RBZ`BG{Xuw`;!nljz)b",
      "name": "@MAP/WAVE2/RANGE_MONSTER3"
    },
    {
      "id": "S/[4c]!@@?CZLs_vzOvb",
      "name": "@MAP/WAVE2/RANGE_MONSTER4"
    },
    {
      "id": "LC{sla`}:d{6nU/plP3+",
      "name": "@MAP/WAVE2/RANGE_MONSTER5"
    },
    {
      "id": "ZGOXy5Akef=_x/}]ip|h",
      "name": "@MAP/WAVE3/RANGE_MONSTER1"
    },
    {
      "id": "cTMZa0fA@IZX.|7[(C?d",
      "name": "@MAP/WAVE3/RANGE_MONSTER2"
    },
    {
      "id": "O3:o+djrdd||@fO00~MG",
      "name": "@MAP/WAVE3/RANGE_MONSTER3"
    },
    {
      "id": "7Xy$btWD}?xvRz5U7-0*",
      "name": "@MAP/WAVE3/RANGE_MONSTER4"
    },
    {
      "id": "YTt8)$a;U}FTS?FBH?I(",
      "name": "@MAP/WAVE3/RANGE_MONSTER5"
    },
    {
      "id": "S{Ed8u8-]AkE83#-}t^A",
      "name": "@MAP/WAVE4/RANGE_MONSTER1"
    },
    {
      "id": "VZ6QPHJ{|WrD@w%RSps%",
      "name": "@MAP/WAVE4/RANGE_MONSTER2"
    },
    {
      "id": "i9ho0k#L7*kwE4Uk98M.",
      "name": "@MAP/WAVE4/RANGE_MONSTER3"
    },
    {
      "id": "OI@gT*ig6$Ybh${(mw{m",
      "name": "@MAP/WAVE4/RANGE_MONSTER4"
    },
    {
      "id": "EC;ymvE+!-;^aoG[dP#n",
      "name": "@MAP/WAVE4/RANGE_MONSTER5"
    },
    {
      "id": "+KvwdY{l^J-/prn8s-u{",
      "name": "@MAP/WAVE1/TANKER_MONSTER1"
    },
    {
      "id": "juRBS?vxrZbXFDSj^XjN",
      "name": "@MAP/WAVE1/TANKER_MONSTER2"
    },
    {
      "id": "8:i2]M~iX!g4lKa?W83v",
      "name": "@MAP/WAVE1/TANKER_MONSTER3"
    },
    {
      "id": "j@k-JND$L`;9}`Vk#l=m",
      "name": "@MAP/WAVE1/TANKER_MONSTER4"
    },
    {
      "id": "0D+9;$:vOHaiZ(vGYT0z",
      "name": "@MAP/WAVE1/TANKER_MONSTER5"
    },
    {
      "id": "V]y.D8D8,JOYOD!y:X,#",
      "name": "@MAP/WAVE2/TANKER_MONSTER1"
    },
    {
      "id": "|UAV86tw^5[(pv`;$@Dp",
      "name": "@MAP/WAVE2/TANKER_MONSTER2"
    },
    {
      "id": "xje-3G(`eO,qIxqr[7Z=",
      "name": "@MAP/WAVE2/TANKER_MONSTER3"
    },
    {
      "id": "P(/hn)tEc-}IZ@KC*mS~",
      "name": "@MAP/WAVE2/TANKER_MONSTER4"
    },
    {
      "id": "W9Yogw{13,TXfxva=8./",
      "name": "@MAP/WAVE2/TANKER_MONSTER5"
    },
    {
      "id": "}o/zNS4p=`BW2XxM*+HS",
      "name": "@MAP/WAVE3/TANKER_MONSTER1"
    },
    {
      "id": "(w@9LF114Kqs$Ucqpx:K",
      "name": "@MAP/WAVE3/TANKER_MONSTER2"
    },
    {
      "id": "vrlb7%M9K0[dZkJ!weQ#",
      "name": "@MAP/WAVE3/TANKER_MONSTER3"
    },
    {
      "id": "W+}+LS78/AYwo.zP(o_S",
      "name": "@MAP/WAVE3/TANKER_MONSTER4"
    },
    {
      "id": "B5KEhV4i/K1I7vjFf%z{",
      "name": "@MAP/WAVE3/TANKER_MONSTER5"
    },
    {
      "id": ")mNtU@?tU!?WGVBISq|A",
      "name": "@MAP/WAVE4/TANKER_MONSTER1"
    },
    {
      "id": "[`SS:qKSxCFUrqgNu7QN",
      "name": "@MAP/WAVE4/TANKER_MONSTER2"
    },
    {
      "id": "#J~)qn|)CeG,bx$g?SS+",
      "name": "@MAP/WAVE4/TANKER_MONSTER3"
    },
    {
      "id": "|:ZKu|Ep5Gu9NqtqM.UL",
      "name": "@MAP/WAVE4/TANKER_MONSTER4"
    },
    {
      "id": "F+vS{[pn!N#S~RQ1!!Pb",
      "name": "@MAP/WAVE4/TANKER_MONSTER5"
    },
    {
      "id": "?e|lS;@P$LGdl%.YThrU",
      "name": "@MAP/WAVE1/BOSS_MONSTER1"
    },
    {
      "id": "L%Zh1B8e{`6~|)_AGnCw",
      "name": "@MAP/WAVE1/BOSS_MONSTER2"
    },
    {
      "id": "U4o%plV!_Y[:1a+22XUI",
      "name": "@MAP/WAVE1/BOSS_MONSTER3"
    },
    {
      "id": "0Wm]k#8}CQrYOcRnqnl+",
      "name": "@MAP/WAVE1/BOSS_MONSTER4"
    },
    {
      "id": "Tn2YaBBcHi(SjGJH5OOs",
      "name": "@MAP/WAVE1/BOSS_MONSTER5"
    },
    {
      "id": "bdu.h=S6a2K383d6[l0]",
      "name": "@MAP/WAVE2/BOSS_MONSTER1"
    },
    {
      "id": "grj[qw;u@V[,ulT7sUP{",
      "name": "@MAP/WAVE2/BOSS_MONSTER2"
    },
    {
      "id": "x3GfF#Gb#zs~no=ywYnF",
      "name": "@MAP/WAVE2/BOSS_MONSTER3"
    },
    {
      "id": "e^,Xgp#w(u`7bpRe]}o]",
      "name": "@MAP/WAVE2/BOSS_MONSTER4"
    },
    {
      "id": "C8WN9r|O{H/|0=fy1Ng)",
      "name": "@MAP/WAVE2/BOSS_MONSTER5"
    },
    {
      "id": "Kyt_w7yr92nlu`|oXjxy",
      "name": "@MAP/WAVE3/BOSS_MONSTER1"
    },
    {
      "id": "TeH`yg{K+M9|Z)zewHs/",
      "name": "@MAP/WAVE3/BOSS_MONSTER2"
    },
    {
      "id": "/;![uK*Psua=hj}bK,X3",
      "name": "@MAP/WAVE3/BOSS_MONSTER3"
    },
    {
      "id": "hC1zKWW]o25k.b3P8Ciu",
      "name": "@MAP/WAVE3/BOSS_MONSTER4"
    },
    {
      "id": "4R.ba@{;5nMMuEA1i2F^",
      "name": "@MAP/WAVE3/BOSS_MONSTER5"
    },
    {
      "id": "zik|vNGXtgVWAFwvIq)C",
      "name": "@MAP/WAVE4/BOSS_MONSTER1"
    },
    {
      "id": "E~8u_^=+jNS1iBdW1f,t",
      "name": "@MAP/WAVE4/BOSS_MONSTER2"
    },
    {
      "id": ")TK]V@jG5q-^*l@$Ftm9",
      "name": "@MAP/WAVE4/BOSS_MONSTER3"
    },
    {
      "id": "!ns`o+.|d[y*sKS6T`x-",
      "name": "@MAP/WAVE4/BOSS_MONSTER4"
    },
    {
      "id": "Q[md$LfE/#cMVw^O`jTJ",
      "name": "@MAP/WAVE4/BOSS_MONSTER5"
    },
    {
      "id": "V7aJIj;|,SVYR,f-Z92l",
      "name": "Gem"
    },
    {
      "id": "-lqB]K+L%W6QTyIuW3qt",
      "name": "@Unit/Variable01"
    },
    {
      "id": "-xP)=wA$6J{edP+nAbo{",
      "name": "@Unit/Variable02"
    },
    {
      "id": "|.5!8?M.wa`.Lk1|f@}6",
      "name": "@Unit/Variable03"
    },
    {
      "id": "p`];^G+@p({!P!_gj#sE",
      "name": "@Unit/Variable04"
    },
    {
      "id": "npk5U300~@!ac%xx(oz]",
      "name": "@Unit/Variable05"
    },
    {
      "id": "wt3WU)}LaokssW:ngrT|",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "^//)Oqw=GJdvMo`k=Lzh",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": ".6PYf11M{uF^vxAG0eG*",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "k5he~+{,9aQ6vQTMns=8",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "-WrsG$2:tDH:|!a(Wy#}",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": ":$]KmsSU;[=p8bqjM85o",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "+GKN1]c;8}!#R;8K]1IB",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "y]e*BH(auMa13KFcy/.!",
      "name": "Map/Wave"
    },
    {
      "id": "RM6`8PgdD3ZA2L@MepBY",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "3+qyu$2iWiYFm/@dOvTT",
      "name": "Map/Wave/Step"
    },
    {
      "id": "qx4|M=ljIn`1|jpW(bia",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "C;x/MU80N8N}f3[:~;d$",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "gA:0Paz6IqC:l=]q{M9)",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "0_UGzh*W6fPbPTE1[u,T",
      "name": "Map/Wave/State"
    },
    {
      "id": "y-q7]D(@[5=jyb|?T!EF",
      "name": "Map/Player/Moving"
    },
    {
      "id": "brsxI^HTaP(}4Ln+L%R5",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "5):QCzYIw8,~Ipe=7}e6",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "=q+YkMAp-|R#MZZ/E;2?",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "-{jB./h/z_Us`)Gy,(^I",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "#BKG(~kE-7CYyI!bt`5c",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "%Pe8=OM)+8ELPX9P%luX",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "}b)sZPF5uXFVMqjYG5_Y",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "baH*-S/K3JIe[$4y(5^3",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "#hbbRa~W.#ui8MF;qzh:",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "IU7zY/JpQ{*JuwRo5Mpf",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "z0acSXr#Oaz0yQSlbFW+",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "F`zr*c8rkfiRC?jpjK;9",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "?WfuWIUIj4@U3P0axT!q",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "Cuj0},HwDbgogDOVa8%f",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "e$2ZAvjLv71UWvN0^RKb",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "2{dD(bvnN)}46W2_}I.J",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "O/6B`Dx2[Z(a1ev3+YT!",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "O84Q7R7#Pz2`0`2=C:Kl",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "3J5+La+7Uk-tlexeMScS",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": ".5~@*lqO$CE%+lS?|_:u",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "//#*@K1[{Qu):^2Ah;Rx",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "0lL~FzmB9})n64K$}n6.",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "MvOnUWl42e(gxwb-Q|Iv",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "I)/^)ePy#4fBk;68Np%3",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "`+xk!+KA6rQ-Y@*/Exhf",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "u%L.k_GfEa#7Zq/?cn4;",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "WT9%tX8.2gxegfE3@*0i",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "We)j3OeQ=xKMBXx(e1+3",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "f$NfpSNK?PxnaK)B7n+#",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "b1^D#jw9)_=Xxv)m1].8",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": ":J{L/@0MZ8%3VQ/Df}Vd",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "2An%3FGRlGg6.7A*ZFsz",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "D-Eycc]OTag`~:Q-}4Nx",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "Y!Xx2%VV^:DkP#)p=DDT",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "d)6J{zNsqqn8#wDcZjMk",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "2OCjdV^59OYQt`+@)93b",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "07Aw~Qvh|~](k@.}|uKN",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "?Zdu$W~DzTfJk@V%1r;b",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "a;vi.h9c{8;_`5T~GeR/",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "0}0HY.gwhCJ.(/U!#Zg[",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "(WT3Q18BNv7{,4[b%_oB",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "#=W5U,9@G0d{.Kfo0tW3",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "vY$iMmUo9!~$05pJD3vL",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "nBR|o{I#RB^]=B6SB3d!",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "}nkc|b7[PYi:p[5vT6I*",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "#dH$?UD_h~qe#6E83i~r",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "TlO,)_I3OH#c.1y{~*Rj",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "^x/,(aUUoj,^*gFWQ/:,",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": ".~28^knOHx*(TXY?|Kg_",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "=A}1|7O]fN(Bx1BAWcRK",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "FicK8].^e6Q:@:_-6dlb",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "D.wTdq0E{E81/j4CEd9i",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "nPUj/Wz0EYEF51p|ybK)",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "@C^H+0@630S$OK56Xf#^",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": ",D1P5V64.Z=)4Yz`_#Uw",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "!cGK$VJ1yU#-(GV.CHfN",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "!jQlJ/sQvPQ,e=8_!I)k",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "M8_UA)^Z@eKDCWy5M$|J",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "FGc0^|@eV+dAK$@/ma_k",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "3sIgBN(ubGSTNf87YMt4",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "zT.8:PK_BSH!eucW,%4?",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": ":X,OX:eMg2cq?/|S|LHu",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "To6l*{]rpTB)~iD*5{yN",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "EI02_-I9^6j-L^];=Zud",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "v.Z3*bD%g`-s)Z?vBl@I",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "pL^|DOo)fKYMIS]4nPj|",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": ")zwcyFn6QM)S4)hTS}PJ",
      "name": "@Map/Progress"
    },
    {
      "id": "|8:R/@z+HjYrmh3:_AIu",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "kYLG{l3TO,olZ^K-Y8$z",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "@p(t2+qk8p(Kl[9bO8?2",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "pBtEUyJLDFj$z256YpsK",
      "name": "@Buff/Variable/10"
    },
    {
      "id": ";Y?o=p33OGE7Hrr~I2Ft",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "?WqQz5i6$2$v;ElZGD}N",
      "name": "@Skill/Variable/05"
    },
    {
      "id": ":1Kx5J.z*:GEb5`:+:Sk",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "+B0_c^ZWY1j=pN!Stw?.",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "(oni6p32^-R**`Xuk{*h",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "Sa{+dnp4Ltofg863C~:V",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "nPk+,8+CPJ+9=h(:_sR|",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "xsw6VYn;6[AZye]t6tp8",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "kG_4dloOcV4Q9K|5vvJ2",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "kU7spV[aL?eYXHvf$;mM",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "kk{,7Oqc+6C?-%c!h|D:",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "x{{bcG(?G:Do|O9Sv!?q",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "^4:oS=86S5hjT2R:e6@]",
      "name": "Map/DisplayWinningTeam"
    }
  ]
}