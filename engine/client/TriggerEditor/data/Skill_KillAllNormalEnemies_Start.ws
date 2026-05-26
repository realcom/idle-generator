{
  "blocks": {
    "blocks": [
      {
        "extraState": "<mutation itemCount=\"1\" metadata=\"[{&quot;comment&quot;:&quot;Team (필수)&quot;,&quot;name&quot;:&quot;Team&quot;}]\"></mutation>",
        "fields": {
          "NAME": "boardMethod:KillAllNormalUnits",
          "THIS": true
        },
        "id": "|oj6L`S0Y66,u2pQRQfD",
        "inputs": {
          "ARG0": {
            "block": {
              "fields": {
                "VAR": "Enemy"
              },
              "id": "lIBUsC5na.M1DYpH]@b@",
              "type": "teamtag_get"
            }
          }
        },
        "type": "function_call",
        "x": 525,
        "y": -1105
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_KillAllNormalEnemies_Start",
    "period": "0",
    "triggerType": "0"
  },
  "scroll": {},
  "variables": [
    {
      "id": "ya3go-t#c4T8;as[x7jt",
      "name": "보석 상점"
    },
    {
      "id": "A/`hvnRLW5/+.c=fajge",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "E9cSPAZ}m;o$ha:Mh(4o",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "U5+McE@|.M%$k}wXa9TS",
      "name": "Unit/Time01"
    },
    {
      "id": "46XPM.7:Pt,Y6dOMy59W",
      "name": "Unit/Time02"
    },
    {
      "id": "U_tx41tVaB%@|B@XN3S6",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "b-zT.p7%]n4o:uC3zh4T",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "I9+2ehq:!_m-5)Wg-J:z",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "^#N++sX2Ml=fuZ.`$8k0",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "5r^*b4IVqeA|AZN_0E^;",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "Myu%YvWZE9IFLYU^sJwA",
      "name": "Unit/Tick"
    },
    {
      "id": "=Sz||NSKS}rQ3Gt3R(tD",
      "name": "Unit/Rome"
    },
    {
      "id": "Qm$P=Gq@9nq?.:7.nXO^",
      "name": "@Unit/Delay"
    },
    {
      "id": "Moor09D{%;KzM.}T0op0",
      "name": "@Unit/Range01"
    },
    {
      "id": "=cUVKm]V!sCHAP6.Zcaz",
      "name": "@Unit/Range02"
    },
    {
      "id": "yoG:%Prw2aK6a.*k7x.;",
      "name": "@Unit/Range03"
    },
    {
      "id": "j3T7j:Dyqt4e;+x6p}CE",
      "name": "@Unit/Range04"
    },
    {
      "id": "y4y=i6hFkJ:d-i(.d%3q",
      "name": "@Unit/Range05"
    },
    {
      "id": "LB/{X8#+MW;@%50e3gJ/",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "?;nQ|mI_*v6rI%t9Xb2^",
      "name": "@Unit/Variable01"
    },
    {
      "id": "(J{JhEOPshuc$I_9H9|Q",
      "name": "@Unit/Variable02"
    },
    {
      "id": "Cav+Qh98[;z9s8I)fXED",
      "name": "@Unit/Variable03"
    },
    {
      "id": "tsB=qM?eNPHGIMM+])N+",
      "name": "@Unit/Variable04"
    },
    {
      "id": "x+dDPUVcT?ItSY/G4!iI",
      "name": "@Unit/Variable05"
    },
    {
      "id": "Ca7f:HLZqQsELt98P}:U",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "Q|m,a/LX8xD)dNTM0[E^",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "E1%]MZTqrP3g4S.iy:l(",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "gaS5}X:R!)I0ADgd`4,M",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "1UbjzJ4S~?Qm5c6ZDHa2",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "GnR#oOHAR[sonnoM%7Tk",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "V|t.jW;ar6aXbjnd(g*r",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "hBuCf8]cDROuXw8j`RPY",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "(8tZvT:A0lSi2FJ?@nW.",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "imtdiCPN(3PzgAnBG3-d",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "@kikxeE0|WE=8Z5=*[%-",
      "name": "@Map/Variable01"
    },
    {
      "id": "3RJQECWaD#;8%k(BDY5F",
      "name": "@Map/Variable02"
    },
    {
      "id": "Gw0@%afFr!Pw`8dTUml9",
      "name": "@Map/Variable03"
    },
    {
      "id": "Xar%mMNw:YK/x+]V:b3@",
      "name": "@Map/Variable04"
    },
    {
      "id": "?vEw;BfM,?#bmTX.h8[~",
      "name": "@Map/Variable05"
    },
    {
      "id": "a*/T9NqlpZm+I=1F-,R_",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "^=uK-[@rObS{ot]:P/9W",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "uub1B2u^1u1z{Yw,hOg$",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "~J:;|`WJ:MLJD$+~X7$I",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "I-kO%@C-|{$h;_H.Tt:I",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "@r[|3:i7iwsgLZu.)?V5",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "m*Q3tJf}uy#;)qWb`DIk",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "|6{*u=0YUgTq2k{pYJT/",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "QQk6}=QQ|o_|Aef)+oHq",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "p[c:Nn9usFrm5xWPaT$.",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "PzBMe.*ae61|rq`_^AFd",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "#N-DD:_XcgJ6+.wU[|A3",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "g0R3a},W|Z:,b:LWC_d0",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "lWM?8nwMl/S)gR54Q0#j",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "|}x}|869i:sOT42Rs/K3",
      "name": "Map/Wave"
    },
    {
      "id": "jT7jaKAQi.`(lk^_`f-C",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "pMa9S0es!LeWt.MIb|q3",
      "name": "Map/IsClear"
    },
    {
      "id": "D+uc)=-={i%WT2{K6%vC",
      "name": "Map/Wave/Step"
    },
    {
      "id": ";+}_p3ta.w2TogD/U9L@",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "b8YO:m]QXz7=(2(jxVhY",
      "name": "Map/IsSpawn"
    },
    {
      "id": "Y5PP*F$KkSwMe~+|%ri%",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "BIq4vZ+}=|Ex#0*:/w/k",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "YHt;sWMt0_,.^NxqFH[2",
      "name": "@Buff/Variable/01"
    },
    {
      "id": ")oJ)ue=8rKCx[Jpq]~OG",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "VqEoIa6Ep#XYQ$_Y0R}[",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "blkmemdQBo!naAXXD=A:",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "8yG`c_)od{)zmMW*~[dt",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "{as3T~5/jda`uMsF6zB(",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "v[ceeg,eHBArG0z#;xqp",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "{]u#QGAAiw%*(QD5cN2G",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "O{!T+NT!9JUuegW(_=/`",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "kTb?tplUr3k$`^6{!]#?",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "x}t*B[2i)bI.p:[))NG}",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "niQww~F*tcUO,qQFQ71a",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "e}-Ty!dV4E2GbmLy4HkC",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "+@}dPe2fjj1dIywRhe1Q",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "deU}wkRKo[{gHR8l^]yi",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "YIT@85LKda5qnD*5|3oT",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "odh[Lq2Y/qHlE)kAqVfT",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "R.)L(q[?*[pfuDy$[h*]",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "[eY`l_;.s|Zwm1|+~e[2",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "L`Ey[s_[2YW`rA$wujiH",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "(h#SU83SH~kLStnDU~_@",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "mK=r$JK)U:j:)pUtEW0X",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "N3b)W,lbm8s7_FPZekst",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "BYjA)l:,K1HrH/MC1XN4",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "X*LyqyPPZ{DWuLo8EIm,",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "/wTrfk4q^@/?|6C#LRt?",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "^5~`K:|*|3CX3#S+Xj=W",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "Fw1cK4VST0XEFhaO[oEB",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "/}c8kj6fO-fD@(-y0n*V",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "|:_EjMG!yQeFj7.A0Uq8",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "?;J~[V/b0e/uWgJ=HF)I",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "H2NYUPxZt1l/h;?3.Zy|",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "~xg]qcC]IKa3fUFDqC2+",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "Y!$*rE4ur6ZNaD}AoIBg",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "#TrM/yE:k{zxGJLGzst*",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "D@4v!HJ0-f:Wk-`b^Z$7",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "owszrz,WtKK8#%l(bYDs",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": ".QWSqCdbfk(YYmQ*r/I?",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "mQ1Vs(IRxpCVZUfo4a%r",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "s$x,2~uT3#mWirNeT?%A",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "G=4jk%x|SD,b:69%%%K`",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": ".H5eJYzkGu4/evNmHUS0",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "-}:@!H~q4k$#PDAZNL2z",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "B6P*wB:mI!2Ji/k$bJ,G",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "b;W2W3=**R8E]2#;57(m",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": ":bH_[8AY_;0@A.Z5h!tH",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "of9r=$]JDK{p-t!fi:ma",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "4GhA7[RPLW)NEdK/bvnS",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "ko~I:SgD=hnW}WGS!DT2",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "wzot-O:_Aoz!NTd$k(mz",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "@0RJM2:-,_G#+-GRz/4{",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "s^$G36k.2Wx9HA/-Q~$d",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "D^4T!E~!2m?nG2o@$j*7",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": ".#_8-Io:xUb7*g`qOw93",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "kQ-Y^L].!Vy7A]ai#pJM",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "m#Wvu*{D,;?x(|/E}{7Q",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": ",z1*duE59b6M#}wKKl)x",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "zmhQFM6rS6WWDQzj4(|^",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "+$e=O@8Vsi4BoMaUENBy",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "iN9?:U$WtvYDm@C/I;7#",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "6[`w_SaMD9NHa4**6Bun",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "MS#8Y`;gl]mb]SJ%Q}$S",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "SS3vO0aFzy6^5=uCQB*!",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "Ru.zH548AV-v:u)|yLw`",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "{*{sKiM..jgq[|6F1**b",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "27YDambwz:b`W%B.Pw+e",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "D.e%22B+t?f)Uee0eC,7",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "UCX*A2F-D^e4hn6gI%vm",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": ",/_HMT;{Q8DSOE*3F!XL",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "X.Fxqw+0^X.DcDDs,PO-",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "6y3JY@RE:}b~-Er(+d3W",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "#]26FlnlZ]Y@_tt6AdjD",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "{C_N~oxdnD(@=Br%R+Zb",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "Jw.XFqPk38M?7+aGE1;c",
      "name": "Gem shops"
    },
    {
      "id": "yD}+ovs#nApkv8u[2j$5",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "/17?OLi_Fa.Q,r9exic0",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "cQ0Rs$,(;nEt40Z/TaSP",
      "name": "Map/Wave/State"
    }
  ]
}