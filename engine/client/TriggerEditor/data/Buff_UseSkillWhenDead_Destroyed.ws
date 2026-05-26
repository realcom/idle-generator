{
  "blocks": {
    "blocks": [
      {
        "extraState": "<mutation itemCount=\"5\" metadata=\"[{&quot;comment&quot;:&quot;Skill Data Id (필수)&quot;,&quot;name&quot;:&quot;SkillDataId&quot;},{&quot;comment&quot;:&quot;PositionX (default = unit X)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;PositionY (default = unit Y)&quot;,&quot;name&quot;:&quot;PositionY&quot;},{&quot;comment&quot;:&quot;DirectionX (default = unit X)&quot;,&quot;name&quot;:&quot;DirectionX&quot;},{&quot;comment&quot;:&quot;DirectionY (default = unit Y)&quot;,&quot;name&quot;:&quot;DirectionY&quot;}]\"></mutation>",
        "fields": {
          "NAME": "unitMethod:UseSkill",
          "THIS": true
        },
        "id": "rh:EdD7lZb31e!1WiCtg",
        "inputs": {
          "ARG0": {
            "block": {
              "extraState": "<mutation></mutation>",
              "fields": {
                "TYPE": "caller",
                "VAR": {
                  "id": "zkj(Q#ulgQqN%ZV:qSjc"
                }
              },
              "id": "e21Nqcl2*4S+lR8jCd~z",
              "type": "variables_get"
            }
          }
        },
        "type": "function_call",
        "x": -955,
        "y": -1075
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Buff_UseSkillWhenDead_Destroyed",
    "period": "0",
    "triggerType": "5"
  },
  "scroll": {},
  "variables": [
    {
      "id": "ZfAYEB=^H!A7LLJB+Vbv",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "qCNw51eWx~4N(C6N]~i!",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "!1,AJLY%(o@(W;]mL5rh",
      "name": "Unit/Time01"
    },
    {
      "id": "oVihA]uR4ZxY|@1;ZiH|",
      "name": "Unit/Time02"
    },
    {
      "id": "$$7uElaP*7Mh5TmdF_HG",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "OMAm*A-y.p1jl4^%q:A+",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "r|`*Q!BD:_!+Cs-%DpK3",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "Lq9P]o[GG_E(pJ!9*[G#",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "jnAyOc1S7)d*myMwsZ7k",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "he9e1L+nzipgBBb816I!",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "EDn4rF0apM]Z%2t.~sBy",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "7)-T@ls`=jNokD[91N-X",
      "name": "Unit/Tick"
    },
    {
      "id": "qjF6=wwH((!Kn}:[w-C[",
      "name": "Unit/Rome"
    },
    {
      "id": "vn9:!?o4M^5g_h{!143_",
      "name": "@Unit/Delay"
    },
    {
      "id": "xs#_sM|BL-o^G[Q$)-Y^",
      "name": "@Unit/Range01"
    },
    {
      "id": ",yq@*gf./%WTDAAi^W!r",
      "name": "@Unit/Range02"
    },
    {
      "id": "K9ML)6Joe7uErhTn{fC6",
      "name": "@Unit/Range03"
    },
    {
      "id": "+c*+o^L.4o5d!od9eX5{",
      "name": "@Unit/Range04"
    },
    {
      "id": "7U4jh3Y0DR^!t7M*aiFh",
      "name": "@Unit/Range05"
    },
    {
      "id": "%AeFR_@{#.LA;ZDq3y#Z",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "!OOcFxz{Mfwpb,_(FO.1",
      "name": "@Unit/Variable01"
    },
    {
      "id": "~9D4!2BxWE~jai`Ju#2R",
      "name": "@Unit/Variable02"
    },
    {
      "id": "B(agp7[L#++Ki~zb.h?:",
      "name": "@Unit/Variable03"
    },
    {
      "id": "qw8@5nWfhmU=RN60RL[W",
      "name": "@Unit/Variable04"
    },
    {
      "id": "~yL?;Y}iQ%b,m#R*jUjM",
      "name": "@Unit/Variable05"
    },
    {
      "id": "e]eaR8)LjT}av1ze|,JR",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "im5%5u%rhnQy7RC/lUPa",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "L[5hbW=A(m?IuOK6uNmH",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "9q3Ax:fn+0~peP9YB$4M",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "/:C.;[xI%tP/rxtaI9#.",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "_+yxSqM}5{=%mE6RI_jC",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "C:?fiiS:wfdN]emU.CKs",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "Bp6(v*[(JX7lsAWmvdh*",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "w5h_BKr4^y]I}LaP?ZU0",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "cv1AT]02L=1JR+2sab;%",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "hk-3E#IwOOeWwlpt`F9$",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "nLil3h2|:j6/-G]OENJ_",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "ldi3}:I$+PnD.``2J*Jb",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "S+B@O2}6FxQowgr+gxr4",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "6Qn.|jeyQQaDaI[GdRJ9",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "yH3y,MQ%6|*t5Q.c:@Qs",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "?62Vh7Y9,bgWiIj+[Bf#",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "iOG`:XJM!8(;}7uZ+9*s",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "N/BbrBO2X1`KTt+wGsT5",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "Devx(emZbi,_3[3`OQ6B",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "Yg/.FsGrPNde,b5oq+tz",
      "name": "@Map/Variable01"
    },
    {
      "id": "h,Xy2AX-N(@[Hm}BpV|d",
      "name": "@Map/Variable02"
    },
    {
      "id": "d0+-K=E6B7_jMb_3],cn",
      "name": "@Map/Variable03"
    },
    {
      "id": "x?q/NQ$u@**c0T?vGibg",
      "name": "@Map/Variable04"
    },
    {
      "id": "^P7_G$u?4~{~C5{$C]hG",
      "name": "@Map/Variable05"
    },
    {
      "id": "-gru;J|VJVd6eha,Q-bk",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "ad8.5zIW8JE1{=KuvN]W",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "rS9NN,x~p:#_7a_b:f%n",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "/N:qDOnhRdnVmvz=I!O%",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "QOIr#;BZ_!1%cB:3Tzkk",
      "name": "@Map/Progress"
    },
    {
      "id": "4W;_PE(0w6-l7}%;}kXq",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "F,Rh?IWp.V842B_/|-d^",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "D0=QJ]v+hFFGkCB:Y3Fk",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "Y2wtROg@#r_Vw4MIa%.e",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "ffyU:XrQ#U18!#!7h+=1",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "p?EJJ/F+nz_3I6jZM|H2",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "kG%hWJ%S9@:vy0wHo^7Y",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "81W2y5ouXzbwXwh)pmdV",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "8pR|Lw]TiC.d,i|xQxyh",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "0.goQ+}6-p][AO9fFjMT",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "MqG=,/IK!dR^9sVIdY7u",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "GV;dH/za},-#9qI=PG[^",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "lA6a.UoQyqrVl#G2Q.Dr",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "4`T[VE1d$:T@G7Bnj+KQ",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "nYaewJ(2GLqli;DJGslE",
      "name": "Map/Wave"
    },
    {
      "id": "P2/q2Sr;M6_W~h!hb?1t",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "RG!n7R6qh6GJ-!YpttcG",
      "name": "Map/IsClear"
    },
    {
      "id": "tUd_?@8HAwAj~{MTXc#Y",
      "name": "Map/Wave/Step"
    },
    {
      "id": "F/#vCk`u,X9qde[_/31p",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "m71k0_1TFMie,e?XTr-@",
      "name": "Map/IsSpawn"
    },
    {
      "id": "e8]1Xz`vi|=6~2L|atp[",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "~q[AN1j!2Go:wQ/m2:7,",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "zDDc6KdAdB,uf!Ads{R^",
      "name": "Map/Wave/State"
    },
    {
      "id": "?.wo4YQn7Q3Qp7|LGidn",
      "name": "Map/Player/Moving"
    },
    {
      "id": "zkj(Q#ulgQqN%ZV:qSjc",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "Sg3LTlEN,E^wjVr]yw?v",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "A)]BiLzy^]^{bOU_e:FJ",
      "name": "@Buff/Variable/03"
    },
    {
      "id": ".M[p%|9eRAOUX;*]h7~I",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "|q,kTf$HuuMx|FwJj[6*",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "oTg7E`#sp37~^?2Aeoq(",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "$+|f3P1Bmv}jkeFU++Ch",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "m1u?5$Kh%_D8HM*a~FXc",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "[:K,q2(xNAZtccHbd@p.",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "2y=Y=1@Ika;*J*OhX%Qg",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "G!jqH*1I.8Hc*,p!x/hV",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "k-2ctzdx,@5=~D:77@~d",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "VHsE3el.jx6FsJ^.1$lT",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "HX}2O,ZmAdy=%sYf]`z,",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "fRY~%|[8DTL$pB1Qv4.l",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "09G#Fk8K*R`7QRC%#xI#",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "FXS~?XGH7[}qtXUc@%*1",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "##VjVv5Fyuj6Ff$F#H/n",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "_)K1Y-nsU-qjL;^Ou*B?",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "qerC]Unz8P;0G:3[[jG~",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "tu)b{O@]xJ[X5J2R}=O5",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "B,i!7JP9PQfs{G7:`K|G",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "ab/4#w8)nqidvkWqnOH[",
      "name": "@Skill/Variable/02"
    },
    {
      "id": ".:CO*ys/1y_D=J;EugW0",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "XB:)9?iIggyMp!)=yq*:",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "mns7`826salz]X=,/}^t",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "MV$2j?:#;3O5d:rA0R*f",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "G}{V)LKOJ6-Kl3U7Z(D2",
      "name": "@Skill/Variable/07"
    },
    {
      "id": ";]!?+6-{_O|16Sv}6V!d",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "!_()ejx21HMg{ORmc|0H",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "M`s:!h8tqq3CA$}H%Fki",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "I2m%!62DbqdhkW)Lk]8O",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "zCPhKW;-X1k@w*}c_(FA",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "_U^E/#yf].yq?I1WwN%%",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "mtVH,bLi+O.ciLB{]9@2",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "lFni)[h_w1FMwqQbhU/2",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "P|!2+{N_`^K[1X}1u;w6",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "2[!%%C~!5M2s|6=#[2%J",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "NYm)T~e1RO*ldJ3FFzL}",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "%u/Y5qt?d8so5nN[h[^E",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": ".fHNdZX]iKxiM|=$)GAO",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "-ZjQ4-ESQjl7J(+VP.9/",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "QrLDH6gn9?L:2[-D5giK",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "*)X.r_!u9er1(4~8,Hk6",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "VUy_K,hjiA=/?iygPRpq",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "=3(0Xe9(munp2Iqb}]Nl",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "hdml+b:zp)ZZE7_JcSk0",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "g6h8{SbWg*pDyAv@xT;K",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "Nm8wZ{KBqe9zNpc2!vTa",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "PM^]RRVFSgT3x_cAorD.",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "EaJw6u{DxBh4UgEE@O~l",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "6NmZr!]:o,;|Z(!F|j+M",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "e4hFUO?M~]$I.9zZcX{#",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "p8OBdGg-L-s3?^I~*jN|",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "5Jo4zE`9]GVLoGTlRId^",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "rx;ru]Z#GE}4tX9=(L?z",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "E/mD5k-6UtcNh!eU$57{",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "0^4Z34}-RpMB$^x7=Wy8",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "~^:h$c)bLtGFcmc/0IbN",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "Qy#XX3$?ZB]TA*H1#%*P",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "7-w=`iFN1ab/$]Zd,ZFT",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "oPwJSXg|6S2-?8VrPZ9q",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "~ERv{!Dlz+%r(~rB}P1(",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "v9Setc1Y$}^UBcMYkBu*",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "Jb.IRq8w~vprd?zkL8VA",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "=Q=f+cOS!Hh#0%FY+o^G",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "=]ZhvuF]kIP,m$6.Zuc9",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "|${#7zO_C4Cl]IfEim0@",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "MX8S}aoF2FZ$Zj;WLZ[Z",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "e,fyf:cB(Hj2vNBf{utr",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "roCxHCoz-NT7d`{C6@2`",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "+Zi`u=0@)~7mb#td,#.|",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "Evc+17e@@TYyj6+s6j;A",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "8rcRVP,gc#k/X73J8OTu",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "/-Qz42nyvpVFBlte$~yw",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "GkN[XbAOz6GpD2T+M9|)",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "yP=Q5Q@^-T]3|9y:_=.a",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "s3cfdJ66e0.zuMp4ZCgz",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "-!uf%6n2)0HR@$Y/;{Ot",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "/,hX3P4!3S5,$nFUoVPo",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "d?XDKF8=/vzDx*%=A)ex",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "u+w`+[28/PYSc;84_#4V",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "/%!;/r/@4uu2s.gVLu.A",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "(058LRGmTS:#Qu)*^#3?",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "wdSG08`Ycwe@GbfJ%_@D",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "4Ff8,?#Sn/DW`c$trTPD",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "S^L43X*w@G4XK,(YA?e(",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "-%F{e?73oZ*bM+Ypq9lO",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "9d/na?R@$zs0=Q!l!~4{",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "~:U]vo7n`,p]kD__mOo4",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": ":{=-+wLd.gK*be!~r;E{",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "15fYAvPfc+i0xExrk-`,",
      "name": "Map/DisplayWinningTeam"
    }
  ]
}