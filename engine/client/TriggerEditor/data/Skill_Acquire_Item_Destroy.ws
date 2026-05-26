{
  "blocks": {
    "blocks": [
      {
        "extraState": "<mutation itemCount=\"2\" metadata=\"[{&quot;comment&quot;:&quot;item Data Id&quot;,&quot;name&quot;:&quot;ItemDataId&quot;},{&quot;comment&quot;:&quot;Count&quot;,&quot;name&quot;:&quot;Count&quot;}]\"></mutation>",
        "fields": {
          "NAME": "unitMethod:AcquireItem",
          "THIS": true
        },
        "id": "ca+7KpvVrNZN[HgNb.-J",
        "inputs": {
          "ARG0": {
            "block": {
              "extraState": "<mutation></mutation>",
              "fields": {
                "TYPE": "caller",
                "VAR": {
                  "id": "~ZINIX~V,*lt?iL+k=@)"
                }
              },
              "id": "=X$n4jJ~--@$~_+8o=jG",
              "type": "variables_get"
            }
          },
          "ARG1": {
            "block": {
              "extraState": "<mutation></mutation>",
              "fields": {
                "TYPE": "caller",
                "VAR": {
                  "id": "ulnhR?,LA8dIlMU-dqUA"
                }
              },
              "id": "B`E[dk!X3t;Yfp1n:d^h",
              "type": "variables_get"
            }
          }
        },
        "type": "function_call",
        "x": -435,
        "y": -535
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_Acquire_Item_Destroy",
    "period": "0",
    "triggerType": "5"
  },
  "scroll": {},
  "variables": [
    {
      "id": "Ny*FH)qpqkWaf4D4~+(4",
      "name": "Gem"
    },
    {
      "id": ":Y}0cJalRYVn!l^GSKp6",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "H7a-H2LVT2|j@~)6%`.8",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "fBu_36X$b#{b*ESApc9b",
      "name": "Unit/Time01"
    },
    {
      "id": "?YbuC2$z}DdYq~/!t|x^",
      "name": "Unit/Time02"
    },
    {
      "id": "Li8*phWAjR=1%g``.7t)",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "GrcK,AM7qXGDTl9k,+)[",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "f[6iC7kWu{60p*VnW2[Y",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "y/,]EN:a1ktfx;)!*=yw",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "=(?Uw`N7;|rc|[n7pNKa",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "{t?QaPI+f8.Cy#n:y_w{",
      "name": "Unit/Tick"
    },
    {
      "id": "h/NLex55sQlWwhD?q:j,",
      "name": "Unit/Rome"
    },
    {
      "id": "=CyygV?QYV9$1|s{[DZf",
      "name": "@Unit/Delay"
    },
    {
      "id": "uR.hpAP4D`k39e*ruOLx",
      "name": "@Unit/Range01"
    },
    {
      "id": "`(%3yWR/?_sMu#n[1eHy",
      "name": "@Unit/Range02"
    },
    {
      "id": ";8SjCdWL=okNy.h`{JT0",
      "name": "@Unit/Range03"
    },
    {
      "id": "?~mX]3Z(9EJDinbTDABI",
      "name": "@Unit/Range04"
    },
    {
      "id": "zXTlWZTC.qZYW?_OutL`",
      "name": "@Unit/Range05"
    },
    {
      "id": "wW=e@JvIaL{23YqMw#wG",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": ",^63}}k{0N|}ISO(KlwI",
      "name": "@Unit/Variable01"
    },
    {
      "id": "%f])x#UDvi0q+w4Jvvvm",
      "name": "@Unit/Variable02"
    },
    {
      "id": "?7ZZ0OEZSdJy%t:$-obd",
      "name": "@Unit/Variable03"
    },
    {
      "id": "gEpO6|E4`.3rgF^H`gy]",
      "name": "@Unit/Variable04"
    },
    {
      "id": "boFNq~Yl00m]iGEe1}sD",
      "name": "@Unit/Variable05"
    },
    {
      "id": "fMIj*DQEg:8Kb7o@+H*]",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "IQaj0P:w}8h:s|Wqzxe4",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "jM5he,2GgP)K(!O7npi.",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "_AQ]ybMCxSh=1P1Fpsy*",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "G#}5PeUAF{cIO0;n!rA@",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "p`wQXwhHG3=}i{Auo;4u",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "y#cJ;/~w}=kgnbM;K,lY",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "Yr|[BsRsayx$V|IF}p-p",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "g[9m.EjdFhcJuo:0$728",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "4I*YfKKLizl8O-vh~c*X",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "tv-s7$-]qcST,QO-3A.B",
      "name": "@Map/Variable01"
    },
    {
      "id": "MYN%#[e[|m9Vu;_b{H2E",
      "name": "@Map/Variable02"
    },
    {
      "id": "WQ$*vM`kfWa=Rx]1iN67",
      "name": "@Map/Variable03"
    },
    {
      "id": "(Xj*N}DL|rbQqkDfi[M?",
      "name": "@Map/Variable04"
    },
    {
      "id": "af:OgwqhNxNy;Q1.7jBu",
      "name": "@Map/Variable05"
    },
    {
      "id": "4)]Jga2XuZ)s!vE6ILtf",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "?p18E=T}yGB7/8IL,*~j",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "^NlBY4xU.,AASqVC2DdT",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "3dIio*?Sv]fx4tyv)r.T",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "Y:rZ]Ch6C!FAtrftJ~b4",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "jBdO?DF8~%h!s=xy@S|N",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "6m;h@Er7ZBv58w(;FhI}",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "ztY)qk$bq~tDcykefPN?",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "r10$J6rqoaF%isrZtG|%",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": ",wc$}[50Kb,l^EI#`-J9",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "y[oCmaNt~j)Q7dGZ8@+u",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "Wlh]1QnT-yLo23#*cpYJ",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "(W*Kr*~G/gjEyB`{hfDh",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "Wu%0bSNX}wb*5j`vk{[%",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "=/lyJc#WW1NCqoxp[J?U",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "1hP8!H5kBF2L^kr#RoC3",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "[}(`Mk`IyG05v1T+[+n2",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "K*p8f{M/*I.;4L~?t(*I",
      "name": "Map/Wave"
    },
    {
      "id": "u[i3L|jJDRbw5uz=TcT~",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "~2,svgVGtl}8s@1}QV%a",
      "name": "Map/IsClear"
    },
    {
      "id": "?~F6,#Jlwu;}:|gp5Vv@",
      "name": "Map/Wave/Step"
    },
    {
      "id": "$.8MpH)4u(?qg#gJiCF9",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "uQ!kd;*i@3Kv1;{TL.ls",
      "name": "Map/IsSpawn"
    },
    {
      "id": "[3A;}Ai4VYxlY,T{*CEv",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "RW2x[CO8E3w%_wL,Kid:",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "k[|EqqsYfC%d|:X(bmBB",
      "name": "Map/Wave/State"
    },
    {
      "id": "k,;0)[[;sa14yBWY;(K2",
      "name": "Map/Player/Moving"
    },
    {
      "id": "CNWoxLdguuywzGJZ%pL]",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "j5~Ek1hY14~fEz[#(hd/",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "@Np$lnWX_Jwg@`/aP;Vs",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "S*3J}n8XdudILYLYLRn7",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "T`/cRCp@u9iBbml1oBch",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "%21B5Wz_*b4bgQ68Qv7n",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "u7enk8J9Qar4q0*n05TL",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "Om*3GkKK.wf2Q}l(@-|b",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "}3dupHXO/0keWz2qKOtn",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": ",S/jm32mCVT#Wf=f%dF}",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "8~Y`cFR1h?U[EW^ydR=m",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "`O]kSU+qR_s`VQEVE(_~",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "tUItW95!:w+,U~X0^fMM",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "v!!n|_WS%2246}7old,-",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "`$3tVDxRykS{5{w3uw0]",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": ",N!H5r{WUB`jlQ9rOHu;",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "WL3KSINpqyF^0YfB3zz4",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "~ZINIX~V,*lt?iL+k=@)",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "ulnhR?,LA8dIlMU-dqUA",
      "name": "@Skill/Variable/02"
    },
    {
      "id": ":v,@D3F=aOjZ!10uecJ%",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "ziPSQ~LY}wffx@@2mQTS",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "u(U?Ant3qx(GYV5}pcM`",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "f`+?Y)9((yr$C#J6UQK)",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "5~*U_iowh_#9J5j+f=r-",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "GvG([jw4CgXIY(47o6HR",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "QB-/:O]9=BNQA5mo5~1#",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "Z[B~*2M|.]Ga.=Z%uLDS",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "EM?6|gr,yQhBRSvV$i([",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "~En_ph)l]?n(3}E)Gi2R",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "@6zV3ap{_L[+b]LPq^Cb",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "TbT,L/;7_Lh$Ae%JatOf",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "V-{%`?MC*7+.$/[R[.-6",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "Zb1BX`H!:Mv+(D?Ee0eb",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "K!kZ^}Vj3e[4@HDEu$+D",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "F=I0K`(SZ]mWh{jD~+t%",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "xbt30M(^A[~bZ=r964dn",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "kgUTW5{bYwPr*@ZdX0g.",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "VvnX~pp/_X0)cf^cGBtG",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "xgt*M6p9f-ILk`N8YrB9",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "eH$K5KDFDlW%5+bDZSyZ",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "0=DZd3([c#.N6FO,)m0S",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "wYnEhr_EX+6W^)%~$y!k",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "#yS13+P6!59e-p63f{t2",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "YyTtsp0Jp^YVhq1~aJ`i",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "[HAc.iS*|Xbyj2SK.UNd",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "GpEyH[1MJ{ngd5#0hg8H",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "]!DD+w(ie,wUBQ+~a*@}",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "]vpB7%c{rjjq3dKJ,X6.",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "aYPlh$vF4e`(ZOsn-__o",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "rAu5EPW25VmvyZ)C?Gyt",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "HH8Nz6n.C5PkgQR~KSyS",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": ":#*)+%K8]QApu?=1cS%s",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "]Sni[z.++t-y-MP3~o?c",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "aCQPR.i~k#B{Mm_/;j$Q",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "RfVpMd168`)w[8(ETNnd",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": ",;yu`tky2uSqCD0)6tGH",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "@iA;roUk/l)Q(%[_Yb0N",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "n@mZ~BiGFN|!clBOc1]P",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "z6GV`{j0mj.ug.mm-y$%",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "cJRWA+6eBD~fP%zLo*WS",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "D9u9BRe8W;tMD_;qUV5+",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "TsROO}MgefV89QY0l_!P",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "{}jk9ECqzfW@g=:5^M(`",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": ";PqXJh[.=S!8#|LE)Zn!",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "P(KpkCzDzvC)#YA5I#J[",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "gQe,[U%O2:sdVn^kk6+%",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "g*`,o5,7G{Ti-:U]QdWq",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "X6h=2$qu.@Ph1V|e4!lj",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "m[8K%GhJ}L+iFA+XWo]i",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "e526T,h10d/Xo}yiF@dh",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "Vf7[(`SE#!Ce11[*0eke",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "k0KeH6=`|aVMTBqRr~8h",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "*vtpLh9UjB}fEHz*sWaR",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "3pS,d0N7^5l2/zmg);5:",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "+X,|bi99_{,bQE-b0@Go",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "B1e@y_VEF`HA}cQR9vV?",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "UzN-JHTQ0I-A[pv#d13n",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "Ko_$g29[klZK)3k6:HT|",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "IdkeWZuTf]66yJz]So=h",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "6oF`QSDrNGy8$3,3H:~L",
      "name": "@Map/Player/InitUseSkill3"
    },
    {
      "id": "IMOk47w|8jF?0:e8[=!=",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "mk*U][hFxPAi@iltA0t8",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "ceIMWH-7U(@;9Pzo650b",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "^yi0Y,v@u#~aAQ?3B59X",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "(bppZxs~U}SI^g(Oz1:q",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "LV@aN{#SRi3^7)?(tl!r",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "z7Tfa_650u5CVf(C/-3A",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "$LLmDl,Dp.gp!`)[b{Zw",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "f327,)$qPc/@`iPS@AaY",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "6e@:|VY{xC7FiYcEI9j*",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "6{,NRKd_1cLYCtbrM*7,",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "v0m){[TSPL5Kw5`]~~w0",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "!V9kc/pIdha3rpM^cMpH",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "x/wE5+*BNER],4%/IW~7",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "+h72OLO%5lOu+FJKV:X}",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "2A/MDK2~ExO4!8PbvGV@",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "o#+_NHjDi1seIt,MjzPg",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "H6c.@uNdsmhlE7h)l`FN",
      "name": "@Map/Progress"
    },
    {
      "id": ";s=!5%tbz1-h9c(GEZ1r",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "+!jE_UkW7a^toW#q753#",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "SdjdDz~[.!,9ASHh+:o8",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "DY[0FoxPS]2Q.)HS1nfI",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "p^UNL{|bX9|aN#Sj=y%c",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "~6MNMMtc#:D-a-^[u$Q$",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "SxdeQe._(GY#y/[;g%n^",
      "name": "@Skill/Variable/10"
    }
  ]
}