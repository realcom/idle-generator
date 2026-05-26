{
  "blocks": {
    "blocks": [
      {
        "extraState": "<mutation itemCount=\"3\" metadata=\"[{&quot;comment&quot;:&quot;Buff Data Id (필수)&quot;,&quot;name&quot;:&quot;BuffDataId&quot;},{&quot;comment&quot;:&quot;Level (default = 1)&quot;,&quot;name&quot;:&quot;Level&quot;},{&quot;comment&quot;:&quot;Duration (선택)&quot;,&quot;name&quot;:&quot;Duration&quot;}]\"></mutation>",
        "fields": {
          "NAME": "unitMethod:AddBuff",
          "THIS": true
        },
        "id": "yBx1SP|FuBZI8(*eYH|{",
        "inputs": {
          "ARG0": {
            "block": {
              "extraState": "<mutation></mutation>",
              "fields": {
                "TYPE": "caller",
                "VAR": {
                  "id": "t]qIr=(Vv@A00BfTC]~E"
                }
              },
              "id": "W#@?Qp[{9@EeT?n[+~K3",
              "type": "variables_get"
            }
          }
        },
        "type": "function_call",
        "x": -1135,
        "y": -925
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_DivineSword_Kill",
    "period": "0",
    "triggerType": "8"
  },
  "scroll": {},
  "variables": [
    {
      "id": "B)#F{JizKeqS);S^u/|b",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "RsrBau!T7(9t)|x?Q!B-",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "KXpu`N0hn~_n7_VXG^pv",
      "name": "Unit/Time01"
    },
    {
      "id": ")0:Afy4NA.pZdCn9!jnM",
      "name": "Unit/Time02"
    },
    {
      "id": "]]cYI2gBQ4uB7ZV[@]8z",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "W5|Tc3,ie:pDkl2G7c-x",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "g]osz)R5(/_yng-}(4OA",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "N$|SWnUW]gN*%_Wq$a:e",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "vKIYQ8ECB92bJT49bcK8",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "J5ytlthI(*p{Wdng}*rv",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "r5=Go$dQodqIf6VpkmOm",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "n$b|e}R_9Cyz*w6.Nx:b",
      "name": "Unit/Tick"
    },
    {
      "id": "CQyY3YX{B2?SwV^ry)|o",
      "name": "Unit/Rome"
    },
    {
      "id": "YL(5lM7H=Q@1XhXBa*Al",
      "name": "@Unit/Delay"
    },
    {
      "id": "06F_KjTA:.^S:;Y+muha",
      "name": "@Unit/Range01"
    },
    {
      "id": "S;lk6h:e._)9X^Httiq?",
      "name": "@Unit/Range02"
    },
    {
      "id": "A:EE?JW4Xu!JQ+wqzlvW",
      "name": "@Unit/Range03"
    },
    {
      "id": "-FR?E1R??:t6V()6XK{q",
      "name": "@Unit/Range04"
    },
    {
      "id": "4j/GIGSJT8MN2|WgG-eg",
      "name": "@Unit/Range05"
    },
    {
      "id": "K-c=B?}!c{|DyC}vsVRz",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "DLdrZ{nv*?^%ZYfMu_0L",
      "name": "@Unit/Variable01"
    },
    {
      "id": "}hpO1f1D:6;+%ys$Q9Aj",
      "name": "@Unit/Variable02"
    },
    {
      "id": "otUlBzY]vh{[$H.wPpOt",
      "name": "@Unit/Variable03"
    },
    {
      "id": "SAr8=7bRw?b`T^Jig*dM",
      "name": "@Unit/Variable04"
    },
    {
      "id": "D|vG;O[d$x0Re(r{D_-3",
      "name": "@Unit/Variable05"
    },
    {
      "id": "H%(xj?~q.2grBw(mF.cP",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "?1+-ANg^6}#utCl3X_Uj",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "T?HA,Bd@J9Z;?JkJ2}`U",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": ".u#$Fl22-l85ox!a9^u2",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "wGhuFjMRN2PthiJ#Fh=V",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "^gC8`vn3`_XYQ|go#||C",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "_H4GIGeLWC30[edW%p,T",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "x7w-^8V$`aCpc)*r37QE",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "a81RFO(CpHH-V9NSqVtd",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "P@uvt5qT/1CHPq262Se:",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "c[WiMG/,Eaq308dj@8D@",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": ",zi$%B^fVMo|:]@]lca=",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "~2m;5?Eg_qsH8*tEK5zu",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "7dy!rcXK_^~#;AJuKuny",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "iBn6KYA]u[D?=5ZKLWOF",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "7f|_$^Ymnk`gb0q{ppBI",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "z/MPpTeg}IWB9$]~iY.a",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "ThXJRu)o.Q6uKkAiOYLx",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "9~D)5qJSf7HRk,YTj]|C",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "o=iEWcz91H?.o4z@38`^",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "];q)O[qm./QsBkB98g(9",
      "name": "@Map/Variable01"
    },
    {
      "id": "S?2;^u1AfY{fAB;RFM=O",
      "name": "@Map/Variable02"
    },
    {
      "id": "xbq,X4~WOeWegW.4Q[]x",
      "name": "@Map/Variable03"
    },
    {
      "id": "sfAtRmutt%):!0vj?[i$",
      "name": "@Map/Variable04"
    },
    {
      "id": "Npo4jb(nk/FI9y1sg^4X",
      "name": "@Map/Variable05"
    },
    {
      "id": "OD*;)WQ2uWYo@eNQ$8oY",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "p,(fB6r*|`JMC]]S72Sc",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "ZLOkbN9R]lR[hDUM_wRD",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "rofA]UK~hn6.BSUSIBqu",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "|kHc;q!r7y!:ymTk1v=l",
      "name": "@Map/Progress"
    },
    {
      "id": ")hf2Pj45qavVS~wg^6Ck",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "$H71{;(-8G`Z`8@QE(~8",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "=#Y:_~,be#+%JHB4F9FG",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": ";OPp{gDkfuQAJu5KX^h=",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "[D7.aL*D2`Z1CAV[?uN!",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "P,~K5A~T-Q+`={CsOCho",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "$0,Lx^S?nTd/DAaMub@:",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "RC=$,uTvQt[~G$?1ce?C",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "]2Wl3/C.G,LYU;c(yguB",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": ";zx~BsS#g/]rGRf-*=@=",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "vztcv+PIO0z3]|U1DFp:",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "e#VOG3Zg|RN`xtmrg90Q",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "j~N5,=ANNkO66@M^2ddV",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "GC=ytnr#aG-N=;k-)8H(",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "*}HEE^`xiP{s#Q1@%7eC",
      "name": "Map/Wave"
    },
    {
      "id": "Xvw4[wt+BzLg@GX.QPg!",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "be2*lr0rR:i4#4,y0!fl",
      "name": "Map/IsClear"
    },
    {
      "id": "u;_F!%Y(a3Q8q/6:Mwj6",
      "name": "Map/Wave/Step"
    },
    {
      "id": "_n+]OrHi7hU+$,q=@Zag",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "U:zH{{H]7xpBF,r*ot|Y",
      "name": "Map/IsSpawn"
    },
    {
      "id": "bG96GO3jl79mbgIfl)r4",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "72y0dXRVLB}.ogx0+Yf;",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "A}KnKB@t*KErYi`ntAIB",
      "name": "Map/Wave/State"
    },
    {
      "id": "_Q9lvIl5Z,!MlP^Z^^iP",
      "name": "Map/Player/Moving"
    },
    {
      "id": "e;BFWs!1P)#0lOBoG`Rx",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "f@vIvu9*c.jKc}Ca[}vG",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "xwU#7+lyE62M#$S/.0j+",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "+LpFI*-G4eulMU84:uGv",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "EMCG(8V|r7r!](o~phg[",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "NxzLSI[kz/mHJH#O+;vm",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "oVl4pLr=f,3|`b.oufD^",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "+#)5M2]d_pPM-WxUj-XF",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "g[l-!_sFrc@Kqd^g:NH1",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "SZvIXJh^Rx$~4KkeAz9B",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "7A{nOXlXGO[6t]$(vBu_",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "[wii~v^?gII#XVPNo{_u",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "5-}^s,Z#EUU)tVVl}[{p",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "($O[+EUk~@s9E;[t-WzF",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "Zu-8FmIE]k[6/|xc@~pi",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "}=3S#|z?Fc.$QZZ1CG+0",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "ZeSq4XD;Bg3Z8/RkV=C,",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "*}DUg:#(ag*.Yf/x@:LA",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "t6fS/eBzSXH6KgT2xx3O",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "wf3/z]Fken0G:I4%VFm)",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "nhr[aVMRt)n(ygOm(:9=",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "t]qIr=(Vv@A00BfTC]~E",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "mBA9?MZ3{!CqQ);UY4ZU",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "#1BzLzoyx.1c5Xt[]jdS",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "=sU{50lP+6!vOHMPGFnn",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "1zRn*iH1WF%!`,R(Ho|C",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "EbJT8,45O)[luY6oBpB|",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "W@eD!U}w96LA]2E7X[Xb",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "#1qaH$5hYJ9sZ@(/$M);",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "81h_g(}phUTQ;Z[f5CY+",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "FbyZ}]`j|/C}SZXmPZMB",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "5k(Uj|e5Y;1EcXY6qa/%",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "+OwNZ=S/+_Xj)dMoDdXZ",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "H.~MtPXRLck6oV5Ci],d",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "SZAa97mbKy910PI/kt.J",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "]39`=,yt(vXNOX]u4M_J",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "ve)6./bM$xa(QqeU22tX",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "qAR=(I=4F2H.sGzk0LN`",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "{ySez5nq[45TPW0QcmRc",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "IZ+rT}Nww,:/.4-J,gp;",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "H%)W)SHN1X@@]SJXlnp*",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "$}VG}({D|G/mLj0)9ml-",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "bggyA^HAkKGL[Gwe)dFy",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "~?[RSN7?.**XUT@+;a1n",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "wV24inQ/4%2deoNw[ved",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "7+O)qJy2t/NWk_E^Z{CJ",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "if,:b5C:*p90rN4_zYsx",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "b2Y#%6@ixy01^@NkXt%1",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "6c/;`awB(LrYbn3~e48]",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "s-g.R]B:iFHk7M)b#ztW",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "UEq[e0kHmk}+EcgqTk!.",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "Ke_,x0y[hmc*.t(Go=J]",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "y00|VVrp6JYU[|@(]v1*",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "B#^8bfujKGh6@cb:@%:,",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "c:^f1{5_~+bXRr!@(Kn(",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "h!DV`_~XIk)1rO#i$l%S",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "KHzwPe,@DwJe0U]afQ@a",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "eGUpn.6:E6RijC.n#xR^",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "Rxc!hIM=#nE0E$%?d~2y",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "X1)W@te=@c=fNpBnN-Nu",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": ")+ju3pQB)qol8,uT#Vm`",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "YA)t3J!Gz;Sq?2k{PgV1",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "Ah{B*JuGyS.I,BK|YeV6",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "5(g$qHoc[+xV#7lvG=|+",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "u]rZC%xjZXkyODf_tZW0",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "1@XOaug;!E5r^HHWPn!y",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": ",`F%t)Pz8~@u]7{~b0RI",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "vW([nM~0IqeZ[2lyy.oq",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "GD?6wa0?edsOD6h:Kja{",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "(*h9syrVG~hGpF2CYtjX",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "d.^*+`:}Ho+@1O||R?Nl",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "]fQKLWgci20H5BN?y9^+",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "7w;fy(AS)|E8DIrKJTdy",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "(YY7]8UUAEBkJpe,,pB|",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "!-B@pYBv*d@H3y8VBW,_",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "^cy+SMLN`,8fPWuslzsd",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "fX5A?S@d|Uk,|s}BI(fD",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "[w@av44j=eKz3|y3BlNT",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "x3v`dKhHjxojA];lPmoQ",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "]4ir6K:#=d,Los9t%G;A",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "{by!b,G{!axr7S+tlB8J",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "FK%-(f6f|(oAZ`C3C[!%",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "oDU7Z(XoWnpZT,X#]xCb",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "`#K^D3S=tLS5S2iBf51G",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "c]00r$]|NqicBhB~01Zk",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "sIV{-[9KF07m43wi@ILG",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "rPSTA@^RAv^-GCn_Xmd4",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "@@Y$GDNJvi+3Fvu:l]^K",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "9ubmt9!A|nCIDxaz`,[Q",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "vNO^]6kUIj:fXSGg5u=s",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "rdDtHkEE]1)6!mf/t?ak",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}