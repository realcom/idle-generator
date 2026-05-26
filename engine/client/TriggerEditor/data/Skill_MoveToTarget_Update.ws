{
  "blocks": {
    "blocks": [
      {
        "extraState": "<mutation itemCount=\"0\" metadata=\"[]\"></mutation>",
        "fields": {
          "NAME": "unitMethod:LookAtTarget",
          "THIS": true
        },
        "id": "i)A=X}[gMMoMsgUt,;Q`",
        "next": {
          "block": {
            "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;Position X (필수)&quot;,&quot;name&quot;:&quot;PositionX&quot;},{&quot;comment&quot;:&quot;Position Y (필수)&quot;,&quot;name&quot;:&quot;PositionY&quot;}]\"></mutation>",
            "fields": {
              "NAME": "unitMethod:SetMoveDestination",
              "THIS": true
            },
            "id": "{_iAec=A(LO8_;!tnbAZ",
            "inputs": {
              "ARG0": {
                "block": {
                  "fields": {
                    "THIS": true,
                    "VAR": "unitVariable:TargetPositionX"
                  },
                  "id": "C#-`7M[I-s}%zQ2:?6].",
                  "type": "variables_get_reserved"
                }
              },
              "ARG1": {
                "block": {
                  "fields": {
                    "THIS": true,
                    "VAR": "unitVariable:TargetPositionY"
                  },
                  "id": ",+rFCuuXQkG-HehEw|~N",
                  "type": "variables_get_reserved"
                }
              }
            },
            "type": "function_call"
          }
        },
        "type": "function_call",
        "x": 95,
        "y": 435
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_MoveToTarget_Update",
    "period": "15",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": "3bp|`12z8aKw`+ZmvMKx",
      "name": "Gem"
    },
    {
      "id": "YJ_YRIHlL,(wQZwt8Uz#",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "k(`%MO@2].@$}|Su0]HK",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "o`./!}E{4:j-v-if5~?4",
      "name": "Unit/Time01"
    },
    {
      "id": "=Cs/M4Sk#}dJH$X)Y4?.",
      "name": "Unit/Time02"
    },
    {
      "id": "Mf6wz]!aO]}TH-b5Z6dn",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "xNP=S|V5hQR(xZ(elUPt",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "4zkW86h:`mYB8h(jE)RG",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "Y-`bi[4TFPb+4UH/r.db",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": ")Yd2oz#dM|E|p)x,]@!$",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "6^Wh!w,[uATRNQXPFn!+",
      "name": "Unit/Tick"
    },
    {
      "id": "*q6k:?8M^.ky)b5lm-{l",
      "name": "Unit/Rome"
    },
    {
      "id": "@nfz5N(`mdB}Oj~j(Mo!",
      "name": "@Unit/Delay"
    },
    {
      "id": ".!=Vl$CP,+B?.kxiQ6.7",
      "name": "@Unit/Range01"
    },
    {
      "id": "{g{Aq_fpxDPT{#PZnsHF",
      "name": "@Unit/Range02"
    },
    {
      "id": "R:jUqb/qQw]gWbRDX|w!",
      "name": "@Unit/Range03"
    },
    {
      "id": "3`Y4Lr^?etB$0uaMM!./",
      "name": "@Unit/Range04"
    },
    {
      "id": "|JU;F4t-w30;2%}UYUxO",
      "name": "@Unit/Range05"
    },
    {
      "id": "o[4D.q9O|)3j+/A}F+B:",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "FaozKYQsXhK6#.v{0`fn",
      "name": "@Unit/Variable01"
    },
    {
      "id": "_;Tw`U6GZ~p%B?!p|eQ(",
      "name": "@Unit/Variable02"
    },
    {
      "id": "@`,!GPcrifD62^=2HH1@",
      "name": "@Unit/Variable03"
    },
    {
      "id": "mA6${dVf4m@a@nsbO4[(",
      "name": "@Unit/Variable04"
    },
    {
      "id": "RB4hFAow1DN8X2en/-A7",
      "name": "@Unit/Variable05"
    },
    {
      "id": "Cvjti0*XQ^z5qifJ+|OV",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "9#w)Hu?:s=dwU5W:qHFX",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "|wfJ?C|1ja[Fw-V%k)M-",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": ";hW)U[YWb#6GgbJ]tM;-",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "uC|`b;2[JE!`@?uK8r%q",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "CUw0!ytw%3l`eaC?c8j;",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "M$I)9QV:u,M!3y2(dVC}",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "lSw}p8}TEZ2};im$F(#_",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "!4Eoxe*yUeAKJ!3@f2}(",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "B#bE09$^IU|/R;;trdR/",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "{o4[il5z0!DGH/,uZ!fw",
      "name": "@Map/Variable01"
    },
    {
      "id": "N^0V@9eFTN|}$]Eof:.0",
      "name": "@Map/Variable02"
    },
    {
      "id": "$v}0Kt/QKC+!*dmc8$TK",
      "name": "@Map/Variable03"
    },
    {
      "id": "K4;a:yQC:TqpDwvsT$u-",
      "name": "@Map/Variable04"
    },
    {
      "id": "XAv6!^Jq3`0YDcq,99]Q",
      "name": "@Map/Variable05"
    },
    {
      "id": "cs)2WP[k(~8:T3msR-={",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "2-cp%eTxcJmZ(@faLueM",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "*~KUvXAnfHjLG~xRW_aT",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "eZ?c]ZoJizN)tKL)4U)Y",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "V]dD5W:1434Db8DYwEr?",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "dSipC7X%79*9p^kp{Fz]",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "kA?Se8n/7y*A32gDB(jF",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "`W@6bFz},_Kw[E`cJ}$@",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "xvGI-kskYF8Q1~V.0`dA",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "rxJOa~0:;19X{PT^k5bn",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "eWPkerTselCC(gu5bDII",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "Snu8|YxD/8WY$!jJCWQ*",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "_B-7`-kl#3gQSuWFY[O/",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "Z;Gb~w2%V(QqjTdK[n^W",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "^0Pbr@D]7bknVO0B)=v9",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "58mM93J?[q?d#*)K_45w",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "gXgWPT2a~-ajF{U)6gw!",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "z1jwcuO#ok:D/Rm49X4)",
      "name": "Map/Wave"
    },
    {
      "id": "]@:v(W*^Qfjftdb:}?;f",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "Bj6Wt$Ce}-~HXs{b0@wY",
      "name": "Map/IsClear"
    },
    {
      "id": "`?^)YfwiEM4HwLnqye7?",
      "name": "Map/Wave/Step"
    },
    {
      "id": "PnUtV3-vlnL=gL2Z_dFX",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "rZZ|}Tt[)BKW`?c_mo[g",
      "name": "Map/IsSpawn"
    },
    {
      "id": "-^W}r1;+?UgYLlV^_?c%",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "HiTJ+%LKscD630=NX@4O",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "?.{FUb@t%(?NoFS,Hbz(",
      "name": "Map/Wave/State"
    },
    {
      "id": "QGYs+Rms-;J|U.YNfY7%",
      "name": "Map/Player/Moving"
    },
    {
      "id": ")yIT7S=4Lobu:l7Of=I[",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "a1N1vXiqVg-4bC59svij",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "j0JCV@1Lkdc~b07(5WEu",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "H6o/ivsqAL#Bc(sofxo?",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "qc/_o6_KI$)]kZ97!!kM",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "7-e{JbR*GH_XnFxNA$rr",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "wD/P,;mf0M~Fq0%ow#[6",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "q3Z8?M:EoxLoBH8-ONRX",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "9CPU6jrsEPXWzJPC6c;1",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "Wi]BRVulOhDLs=gK|K%s",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "Ijt!wX=}np.IVyXAt]jC",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": ")Nja(lpcbu?EH)=(_?ZZ",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "}1e,5UO5.?-g$MW$RnUy",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "fHtSE}K~oPNQ~qLYkUmD",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "dPb0kE:#kT]bc.(?/UCN",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": ";o)u6y(wlyE|F:EerX.m",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "X:qJ^X{q4O^`XFg+L/b#",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "irBNxco{f0[t{u;{h`lk",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "9Mw%(k-zJ280;bo6xp6h",
      "name": "@Skill/Variable/02"
    },
    {
      "id": ".0^B%6rQC~S=:%-SkbX#",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "U[Q``GX0=!b4P}eOx/J1",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "**~f[g)A^%OC*`JArE9H",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": ")2%*,/6yXNFQ2$uj|ST5",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "~@tah2`ltgu4Fr/`%@~w",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "r~[!!jF6{_Oipm=nU=?=",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": ";*SAbd^mH^Zb2BODuc#l",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "(-dPZ6TDwPfkj*Joz}Hn",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "~cKOkmcLdLwJwLwBSf+Z",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "|FpcMY)9J4?X)c(aPi3W",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "`|g2(kXf+[GI2;tL8+`k",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "ZhB[6V=UNI,5S[dDs[(e",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "geti%)cBmPJxr-SmFg]X",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "/wv#DwJP1W)t%#xij{_X",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "00F=D:gE}@Uh%X*TSGDl",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "aT`xTyijLSXH~WRZB;0S",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "]q7O]`Jx^57O;]FqSDkZ",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "v_,`ckHWd|8{kT%ckPn/",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "@LI^nkSqj6@c*9,79ebG",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "1kCC3bB0~$S4!lgpR;7+",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "((fR}]U9H*xfHimW[@Pv",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": ":I;{(,pQ7m~HS@UgLEOx",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "74W)6(v_1$qR|@*}bE_G",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "2#uC@Ze{-YBal.9m@SP(",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "6NXDE*h#s_4|~CpvvReX",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "(8@E1vm?m9@DgOx(omx_",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "jp6ZDy:Udp_:@Eo$BEMA",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "%AZ5gGQ6[?X+WUA8f^C1",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": ")TDyM`S%vfIuWrL.twZS",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "qRNK|rop-alGg#W=kR]:",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "D2tjed_;:|~u=so2fM;m",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "x[sE0vHsehc=JaW.mVYL",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "c#HO6Jw7#Gvz)]!(Q:zw",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "InKt?R4P7X2IOlgGu|M+",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "x#@QEnbYcViOoerYJgFH",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "Hl#:!Tr}sUMG-sd1]UVE",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "]~9*[aE}0Si]u1N;jLTt",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "Swsl82CD?JwD}9`FdYA#",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "([vF:T!``Qh#[sRbNz-`",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "8Bcc}iXbgaS|gD^Fb?|~",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "_1!^!)ifB6|/~IFaz4d9",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "kWeHX=ifu|u@s6m]|T3A",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "*M/B|ZY6e/GOj!c4i4{V",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "TYDbS2I}0h(|8M61|47i",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "ciuh,0UT}RJ3R,4X5mb5",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "L-:9P{9Aeqxl31,km.Gs",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "C*9KMOVuwPy=LbO)08^z",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "t-KN;p-/G1s3M53w@31]",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "b/7,2I`HF[VDhhpk}8L_",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "$G4PZR;Z]+L?id4h!(BU",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "3J`oXkC,qB}g,+Mf_(HY",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "k1wfS%O$L!Cm7QX)Y58_",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "VEerGs_-60*cB60KSEXz",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "_9G7qmON.nZPB^7pN2Qn",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "]OAl7[CNoXI}E!)]:6H}",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "o_4|F(s~H!0qo7-NIonf",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "|;~XNj1X(dXb?JaxX0Eh",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "5qC`zErKX$I1F2~+Oo+Z",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "$w~0s}]K}OOD;A1_0z5y",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "UW]i[S/89-ZBK]QwkYJj",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "Os+M:8XoBV%K5]g;Yk^$",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}