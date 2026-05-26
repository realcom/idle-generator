{
  "blocks": {
    "blocks": [
      {
        "id": "=LOcVa+r(iJSRC0,26z;",
        "inputs": {
          "DO": {
            "block": {
              "extraState": "<mutation itemCount=\"4\" metadata=\"[{&quot;comment&quot;:&quot;Grade Up (default = 0)&quot;,&quot;name&quot;:&quot;Grade&quot;},{&quot;comment&quot;:&quot;Rarity Up (default = 0)&quot;,&quot;name&quot;:&quot;Rarity&quot;},{&quot;comment&quot;:&quot;Weapon Category (default  = -1)&quot;,&quot;name&quot;:&quot;Category&quot;},{&quot;comment&quot;:&quot;기존 아이템 삭제 여부(default = 0)&quot;,&quot;name&quot;:&quot;Value&quot;}]\"></mutation>",
              "fields": {
                "NAME": "unitMethod:ChangeRandomInventoryItem",
                "THIS": false
              },
              "id": "w$:9kqK1.Q,k[u?J9Rp:",
              "inputs": {
                "ARG0": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": ".To:u(6[!AB}n`:h?;CA"
                      }
                    },
                    "id": "OPKs]Gir:5E}Sy/oAF4b",
                    "type": "variables_get"
                  }
                },
                "ARG1": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "XFqDj+l(giaSF7}B[LQ%"
                      }
                    },
                    "id": "sNklpet4lewx#bi[9kbd",
                    "type": "variables_get"
                  }
                },
                "ARG2": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "r?eC=06bOOR4DEgSMpYG"
                      }
                    },
                    "id": "2f50KCW]3WGdxrV{F/Js",
                    "type": "variables_get"
                  }
                },
                "ARG3": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "board",
                      "VAR": {
                        "id": "r?eC=06bOOR4DEgSMpYG"
                      }
                    },
                    "id": "vmod+y9kLgMkSm~*T@{a",
                    "type": "variables_get"
                  }
                }
              },
              "type": "function_call"
            }
          },
          "TIMES": {
            "block": {
              "extraState": "<mutation></mutation>",
              "fields": {
                "TYPE": "board",
                "VAR": {
                  "id": "_/Q-pH@*IycC(36!ghaR"
                }
              },
              "id": "OSEY%L_!12+uo#-EY!ko",
              "type": "variables_get"
            },
            "shadow": {
              "fields": {
                "NUM": 10
              },
              "id": "%UYUXQ=s]J68JpHlUbgW",
              "type": "math_number"
            }
          }
        },
        "type": "controls_repeat_ext",
        "x": -875,
        "y": -205
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Skill_ChangeInventoryWeapon_Destroy",
    "period": "0",
    "triggerType": "5"
  },
  "scroll": {},
  "variables": [
    {
      "id": "4BJCf)C#xhb*Q$W}`-4C",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "+EGM2m#Gb^mnK}EphhH|",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "g)RPssnaVH9o[(#,+]9T",
      "name": "Unit/Time01"
    },
    {
      "id": "Sy%#!JU{TzbLF]0M}e.L",
      "name": "Unit/Time02"
    },
    {
      "id": "XHiyj6}C)*Bl7vZ;aK?T",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "XZHj|3`={)BH#f+{-RfR",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "ZVGKVCl8F2q@u2(I?FWX",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "+hkHF?%#k0,L16%B)NxE",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "N?gXopSuZ-O}wRV6EBOt",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "|q4ZXK|Q:A[OIfQ_Jn]T",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "CZ@o#Jk](l-TM1Se7B^/",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "lM|nqynK5b/$xT94E`]*",
      "name": "Unit/Tick"
    },
    {
      "id": "*R7Xz4(M%!p3Fo2YYCba",
      "name": "Unit/Rome"
    },
    {
      "id": "ES.XKEts{^dQZPyphbSq",
      "name": "@Unit/Delay"
    },
    {
      "id": ")9iQg/:bvW43PqH@82eV",
      "name": "@Unit/Range01"
    },
    {
      "id": "!G$--{~{MtK9b4Hhj}q5",
      "name": "@Unit/Range02"
    },
    {
      "id": "jABUXCdPi@J~oe:D6+{j",
      "name": "@Unit/Range03"
    },
    {
      "id": "WhkA-Rtbqh`g:xC7Y~Gk",
      "name": "@Unit/Range04"
    },
    {
      "id": "rAyP[DN0u9_WWu|/s$^x",
      "name": "@Unit/Range05"
    },
    {
      "id": "2P*U.,A4n~mwxjk^L%9n",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "l-Sg595rJvK=X[f87I60",
      "name": "@Unit/Variable01"
    },
    {
      "id": "~*~GpTM^#O0.Hb!92.63",
      "name": "@Unit/Variable02"
    },
    {
      "id": "FrTxI_NBs?8fYgjmr[S^",
      "name": "@Unit/Variable03"
    },
    {
      "id": "?i%=-MT)GE#k2wH0%LrG",
      "name": "@Unit/Variable04"
    },
    {
      "id": "zK}l-ET0N*2NxG*Vex$h",
      "name": "@Unit/Variable05"
    },
    {
      "id": "e|Q5djQ;_E9]|wRH?eX5",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "dn`U5I=VSdNbsr02lSO^",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "2M!E-z:Pe2#Ggtp@EiB`",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "1@$NVL]VfIO;u7}7;a6b",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "F3`mJ*JrWLzN@(xBfwne",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "X39!J+WHJZ:H2rNvdA;G",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "?%T2T1g/;;rYOa}OUS55",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "rHsOjn/._vKYgKRJGh`%",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": "?SH1*s2m$whAcM+Y@G_n",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "*Ts37md4`P/p_qeySEPx",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "-U~cnEat.4)a=6Dk$/$f",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "cwo+=tI2Ix$Rpt8r%jL3",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "BvI0/0y7*1ezo_,8/%?7",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "JU!opI#g(w@BZH-O$L5e",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "950#t%=v-9bc#*hFA(Hb",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "pQ|B`ri@R~v=.vtsqj|p",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "e9l=!WVJkp@MZSHpB)91",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "H31GC==9?0.OtC9jUY=}",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "yDNjYGi9#aGDG0M:S8vX",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "!kP{|oz4t`-TX;mfK4D)",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "RxX$:@*iwfm/t_eYa@5Y",
      "name": "@Map/Variable01"
    },
    {
      "id": ",%}U9t[1Sg6[T*o`Y`@f",
      "name": "@Map/Variable02"
    },
    {
      "id": "(}:e^Z-U~A)XM;Zf14Mv",
      "name": "@Map/Variable03"
    },
    {
      "id": "drQTq+e=V?:C!OzUHb[T",
      "name": "@Map/Variable04"
    },
    {
      "id": "#0pQ0Mmc!jjDG{qd(]XJ",
      "name": "@Map/Variable05"
    },
    {
      "id": "xIX_O0Fy-v-=tXI${+Oe",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "!LZ?~k!u._Bza~*{k,W8",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "V$FJR!Q)8^so%Z*{pBE6",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "$@E$L/MU3WQ,:0$,:%Z4",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "4;{y_@an-uojl2|VxLq_",
      "name": "@Map/Progress"
    },
    {
      "id": "j0~Qb6*)?_7?+lbC7eC!",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": ",hte$#)n@u3H*{ZM[;eF",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "N0TaAt[20$*-g2J$FrvV",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "_,KsS:)a2KNq;rSWqBom",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "cs.36:cRSg4j6[wjvl1=",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "7*@zA.jU:GMFh0)AeyNA",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "(N@d*cSe{X0)aZObf#OJ",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "XE:`HjzgmD9X.JT0x6rZ",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "J#RU!P4Z*pzHuU[O-ol5",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "nC/dTnD@kvTO~`I1aJr[",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "IvSfTUzM0Ekbczd.+=mK",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "$W81PiBSO_8$WrHUZ4ZA",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "zT+F_!L|yqp$+LT)4*+J",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "bkLKOn[J*+U[!KMz0Euc",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "%a[K+T9e{7zYG9BEk:|1",
      "name": "Map/Wave"
    },
    {
      "id": "cm+^6a[GO+gw1]}i+Il2",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "Fmrs@?#((avLx4@!2E!W",
      "name": "Map/IsClear"
    },
    {
      "id": "SMz9*kC8wB*2QQE6R)LA",
      "name": "Map/Wave/Step"
    },
    {
      "id": "xVcV7L)T[-Bgm8*;;Zmd",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "Avf4/k(P*Jvu9o%0,ukK",
      "name": "Map/IsSpawn"
    },
    {
      "id": "csX-lrQ(j)dR{.]LniL0",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "RGDHj*[EY8$3m9PCv1D!",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "WN..*6C?$qsXh#Yc3V=h",
      "name": "Map/Wave/State"
    },
    {
      "id": "dCycb!G3`#@YC[5@=#{(",
      "name": "Map/Player/Moving"
    },
    {
      "id": "W5~[r`t%^RkkN{Is#:3,",
      "name": "Map/DisplayWinningTeam"
    },
    {
      "id": "#7IYUNl/QTyMouGNfEwR",
      "name": "@Buff/Variable/01"
    },
    {
      "id": ")3bv^w2o{;!iD~INON-+",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "H/;Wb!`N{eL2Gl25*U5u",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "vGLs0o.w5rdH%~,T.OM0",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "$^K]Ky$FV/xaS-)]Jxmh",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "]nV}p]7X?^PIJy7!Agr{",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "h71^rqRt@yr)7j[Fd6#.",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "K**tG3??I+CCi_S+5^(e",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "x{[)?YlfGvOKOIRDvEW%",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "OYJRp+KM_@Q$xn`?kKfR",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "/n4^4lY9Y[QV!-6pnQma",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "#ySDkFK,D_RiEp3OG^l`",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "Ch%?dk[9.x1ZPGB4({mT",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "9vF6O=uVoUK(9CLl_av,",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "2f%#b*|ICTP/#tEx8oRW",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "uQS!Eftw.S}_LCP;xt[l",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "AOBbe#py/0k)7tVMX)T}",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "S~dgQUCb/=ixdq~!]U_p",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "R-)ynkHAI5o-75p7-oIt",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "Of5Q]#IsJA?oj!DX$Bt2",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "4CyL.!q{@H/6o]T)Sr(k",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "_/Q-pH@*IycC(36!ghaR",
      "name": "@Skill/Variable/01"
    },
    {
      "id": ".To:u(6[!AB}n`:h?;CA",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "XFqDj+l(giaSF7}B[LQ%",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "r?eC=06bOOR4DEgSMpYG",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "8zPvDiSrN1FAu_h9.^)a",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "CC]lIZ`bEJF-S+diZLhP",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "Jn!-z-A~WvRK@l`#34j(",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "L-Ey}CzG.6}QVczX9KeY",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "7Bf$`|uza9pjKIgaJ}z%",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "j8xD|mu*c((Z{8qTKt[F",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "o~^iQ7mgw~w4)yjB*A|J",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "[R,*afpNrt7(kg{leR$m",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "N+,0`]IrHZr.*yPwE{fd",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "|[RhDy2d!4lc#NKBD`fI",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "$iH,{o]CL)z/tk_wVk~E",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "rQJz}@zZ^t{iKfszcMuO",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "BvZek-2QCWEj5HyYRRP1",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "N6?X8%|^u(lUud;F+,bz",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "P`)];ncfKi6j@EI;?0C5",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "wfT37yb57/GHjrcME31@",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "saR,}Wr9a|iX^Qs.gQia",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "eGDRPaV]#]{PPGhku53C",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "FTgpdd;CfN**y/haR5?h",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "{MggqbF$tRo:1x0noY4/",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "AJno7l_A29Yrdfw%gZx5",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "DRc,)*RPS`bU`Bo)YCqN",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "HQ8ebw0c:b{s8P`Dv;g%",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "?(}IoNM5l@y)dK^H*P(t",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "bR1H^F}LC5~Q.om9qs0q",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "a@MHz}Fx2SKQDk)(hPN7",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "}FYXs*@JZ3yJxlsitHda",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "p:FS#zshROjY#B(4B9LH",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "#d0@6h4.U72{xBqUJROh",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "7a]#s|*gtqaIM^IQf1Ct",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "5Qvjr#7A59~J~qW)X!wi",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "{~nxwWVRR03A@Mbjjfhw",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "T}DY#LG=:;=p$g,m*kC;",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "{V[K%+mZu-ye-,En)=KG",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "uymN+%WEm!#*e7Xc1c##",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "PotHTfKQ,+:,9Yz47aRg",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "U%g6_PI2E;iJ~0zz~D-w",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "iZ`%y^J5Mr?V5=.;D:Ba",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "Q-2sniux9*lxqvnrKGsV",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": ";IzFee}`9|VIj;KZkS0Y",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "9[prC877eCPBjyV8Y#DK",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "EqG:Np!F6cofjF)knyH@",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "x9{I_Ul=GD|Q}jlA1$JI",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "|Z}lWS7b?q]SGe5U5Qv1",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "KzCZ]#Cuy/x4)nl|XaAJ",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "NW=1=Q|jjZVIJpia%{kt",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "VncW+8L$5Skq3VTg@p78",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "eMY3T?XU;OX;#j|v[_^5",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "B)J2EqwYVJ?kqQ1zUMkN",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "wUjq4d6|oB61k#n|iuNk",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "=oS~*6/QCL:}CzV]Vc*`",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "Y.dO@wpGsJE,I|65WuF^",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "|=~)`xGT,dQ.{,nDBQTE",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "kwPVIM6I:1R+S8`G|mQp",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "T1O?w[B5.Z-MK0E)7V7.",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "dteu5xlBRuw(8/O!V1q]",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "t{s|/l.UkbNl6h:pU,j?",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "s).(dx{gP2H#)]$MT:]V",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "+Dwy2y`UCE=psD-l}yQ=",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "@-//B]Q(it2(;R0VKJQG",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "zTcYEJVO@qx(82Ws:]G-",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "3a$IsRV}G]uE;Fh[~ox?",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "AOQ_t|McB/AUT=?uk^Fq",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "Fb7h/m$@Uq6|qGiT+KJv",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": ")ya.wP9kPzAsD1yQGhnQ",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "XKAs/I0!PZ(DJOE10BP@",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}