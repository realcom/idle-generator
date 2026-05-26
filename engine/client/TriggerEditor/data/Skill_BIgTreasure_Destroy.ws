{
  "blocks": {
    "blocks": [
      {
        "extraState": "<mutation itemCount=\"4\" metadata=\"[{&quot;comment&quot;:&quot;Weapon Category(-1=random, 0=Normal,1=explosive..)&quot;,&quot;name&quot;:&quot;Category&quot;},{&quot;comment&quot;:&quot;Grade(-1=random)&quot;,&quot;name&quot;:&quot;Grade&quot;},{&quot;comment&quot;:&quot;Rarity(-1=random)&quot;,&quot;name&quot;:&quot;Rarity&quot;},{&quot;comment&quot;:&quot;갯수 입력&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
        "fields": {
          "NAME": "unitMethod:AddInventoryItem2",
          "THIS": true
        },
        "id": "UA.D5q`4Lm6zyh^|!KZQ",
        "inputs": {
          "ARG0": {
            "block": {
              "fields": {
                "NUM": -1
              },
              "id": "42!m5~V(Jpxuj!]K.!|Y",
              "type": "math_number"
            }
          },
          "ARG1": {
            "block": {
              "fields": {
                "NUM": 1
              },
              "id": "MEav:zpwv9%v1#]QS+5c",
              "type": "math_number"
            }
          },
          "ARG2": {
            "block": {
              "fields": {
                "NUM": 3
              },
              "id": "7x*ZKDb:JTjpTZsJp2{N",
              "type": "math_number"
            }
          },
          "ARG3": {
            "block": {
              "fields": {
                "NUM": 1
              },
              "id": "@P:HJtERWhT?nJ.MHNdD",
              "type": "math_number"
            }
          }
        },
        "type": "function_call",
        "x": -1025,
        "y": -705
      },
      {
        "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;item Data Id 입력&quot;,&quot;name&quot;:&quot;ItemDataId&quot;},{&quot;comment&quot;:&quot;갯수 입력&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
        "fields": {
          "NAME": "unitMethod:AddInventoryItemByItemDataId",
          "THIS": true
        },
        "id": "kLM2]ESo=t[[lz:U=k)(",
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
                "NUM": 2
              },
              "id": ".!RSscG,D$74Af_=Fy1M",
              "type": "math_number"
            }
          }
        },
        "type": "function_call",
        "x": -945,
        "y": -935
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_BIgTreasure_Destroy",
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
      "id": "rC_uu@m#Vv+0S8l5BkvO",
      "name": "Gem"
    },
    {
      "id": "IL_N}F;eZx)nVoj6N0l9",
      "name": "@Unit/Variable01"
    },
    {
      "id": "4kty|fR:#6nRCY7oe9V@",
      "name": "@Unit/Variable02"
    },
    {
      "id": "!OmQ={ebx]ZS);w`F8W9",
      "name": "@Unit/Variable03"
    },
    {
      "id": "SSJ/sgP}zzKc5o^_y4jR",
      "name": "@Unit/Variable04"
    },
    {
      "id": "jt1x=]J^6I0SfxxMSC)R",
      "name": "@Unit/Variable05"
    },
    {
      "id": "AUY6K)D_Lg[1%Vh3E3$0",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "7?{$^:l!DZrj}ms$%ZgJ",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "%gJ`yu#Va`3E0TgW3QJZ",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "5a]5qJ-_vi%:5L4g8.|Q",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "X`Rxa{)-]]M.#_YUgUZq",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "*Sj)rlxct}ND.iPq)D4,",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "5XjArxn]B`ij7cv|Ypr/",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "?tLeM,}u/kpTiCs2!I#_",
      "name": "Map/Wave"
    },
    {
      "id": "@^hk-bfUADK_|f3#QCh#",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "_5gqM92u{6ahW453]m-#",
      "name": "Map/Wave/Step"
    },
    {
      "id": "~kh^v5D;/2NHHSM9o(u+",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "RW95`lhV*|%KrbuHSgo4",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "Pk1`nYp=K4C6FDsFwCdA",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "eey-Zm9fg}M.YBX1#AN.",
      "name": "Map/Wave/State"
    },
    {
      "id": ".4MsO`Nx2iR1gJ:Zq~U|",
      "name": "Map/Player/Moving"
    },
    {
      "id": "Qe,cuC(=vP=p1Yf)SI%?",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "KEMQTxoyH*^HL=ejwA@}",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "DcCc.Hue/F/$)egyObbr",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "Ra0KNkYltwg2s,%V}OlP",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "u3p|V67[ahG8.)=%*3/y",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "(bJ}H=|g{nMod-x%1e2F",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "e#tO0$PvoKEUN,!z{tw+",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "Tu!R:e7#v`N^G{m(g@[%",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "Ye%RXJ9@|3Hqzx_0]O`0",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "j]Mw|C74Z}Yg2@wTz0wz",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "G~7!^O^F@f]ISoD/GQJ=",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "Q;;5F6F9G=W[3Ts;gx;S",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "v8a@oEZpx6:P`G13kt:R",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "X})`Mg(3gg1fj%lVS}V,",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "|UI+Ybq?IX{I?w]o[S)P",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": ";:c3+~]~/@-w8~n;00E-",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "}n)q.WJ#/?#[,nhf!pd+",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "N{jNDz/xb$ju4]S::ZM2",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "C}:8IfvWyF8(,}Bzqfy/",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "GssxS:zh#GVOy=F-wAKv",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "}bC`U[bOt|z36bd.IBjb",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "ZLsx}-|p@pa/y6iZO9?}",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "G~wTo3R[mzOd_}YUZ=K+",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "p_*!Ih%oG|R0=G=gUB.8",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "Oi!}v.X|XnJOZiD|K):T",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "5-t/J:=nC:2ouP:T8QO,",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "`;xce#2u6i8,?t@*=O1K",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "WcY,wS!T!PCEO=up20~i",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "N3:ZVcx/|`x:`ZX`e^g5",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "Fa1~ak./3BCpc`46Nye]",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "VNG)LKY%kg*9!QpvFy#u",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "D6Fkg5fk9i}2?%z#/#:f",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "g|)CcoZptWeOr=$h.g=.",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "Jak/j7$m8[XsMVO8Dx]y",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "BGqP*0C.#M-_L4t7[E;7",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "xLQV=ND~Oj!i;K57(jx1",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "%[Gf[IMgY.,%3rPNd/(F",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "qldtd21ltFoXIvc|F{*a",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "JXgo5A_{zU0vU1Uuu#K@",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "ScA3L2Hh{1:7i)f^x`-q",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "y?.!~T$T|syckta4[,j_",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "~EEwH.Oo*^%)v/fB@d#C",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "]3SP)e9iw3q6fhB1(4Eq",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "`mtZ1Q92_q^7($OB7$lN",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "UTW_v~UKd8/O!niR83jA",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "EA]vh=8clOf.f`dQu6p}",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "L3V@6$!KefW!tniwD$LO",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "DKs)!m7w{EH`^ts#Yv7|",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "{|O[3n)2;GPC;OO?.}JA",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "!Y(tZ1.E[ozax$5XuARw",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "]6%.08x6UDSoYzeb]N?2",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "vbn1E8-bI|{j$PSe=L!u",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "oA-Gmg9r9,)[Lbo*0@1~",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "_/HUd{ETau,$$*=#S(ms",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "+sXJPSD3m,~f1AiLK6C}",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "R|ns3:HnSpyS+FW$i5%S",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "1}[m0iab+I-g,Jfd$|41",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "5;z:nLM%H`nTQ~9Z.K7j",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "nM5W5Sv*I3,=IwQY`QnT",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "d:C*TA;!H_`R`jZ)=`L^",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "x/$E%6*7My_}$oNGlfb/",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "C-s%9iQ^aRjcV3P2./fC",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "I[W]x59]s5#M^|9T;~vk",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "YCcz4]1cDLdKUd7#2]3=",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "yS^i#jT/kw?/5/8;}L@2",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "M5nYnoR/x-K7jzU(*7{@",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "%h3{-KKwU*(.zMccz-zG",
      "name": "@Map/Progress"
    },
    {
      "id": "^AN+ri@+#sOe/AVa^U+x",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "uRkF~KT3`t3NP`/nBo?#",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "}0Da!bT#ub#w#pW.iRM*",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "tcW^_6+aG#izF)P)Zy_U",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "Hm:Ejt?cp7pX+DL4(;NZ",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "JQ0|B=MEUj-u:Cfgq~Gm",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "I0P_|m[=E.2Vs^eJ1akS",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "ovQAw?nxING/*KPYrYkF",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "!B%~TVSUeHkU,@SrXC#X",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "ecaPI)d=z`R+Q:qAxv3`",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "[W5s}*mztTt=Wt.t5QNj",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "jKDQ_desy/lHlCJI,685",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "ydujL:C4p/f,(AE=?az@",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "2X!o:AVrRRGX5ocK_wcU",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "~Jdr6.1mGnMXs06%{1rE",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "LAY]^4LwTaJeHuw|qdlG",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "1g!*%4r)Z3B?xCT8MOk7",
      "name": "Map/DisplayWinningTeam"
    }
  ]
}