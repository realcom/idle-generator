{
  "blocks": {
    "blocks": [
      {
        "extraState": {
          "hasElse": true
        },
        "id": "C2hl.HOZRv,:Wt~DDOdu",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "THIS": true,
                "VAR": "buffVariable:Enabled"
              },
              "id": "lYZ!MLQKiB2OxepVH^Rz",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "BOOL": "TRUE"
                    },
                    "id": "DcJqg1u%V`[)c+)(mONU",
                    "type": "logic_boolean"
                  }
                }
              },
              "type": "variables_set_reserved"
            }
          },
          "ELSE": {
            "block": {
              "fields": {
                "THIS": true,
                "VAR": "buffVariable:Enabled"
              },
              "id": "i%#Sru`8Lm9.3eQ)R~(x",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "BOOL": "FALSE"
                    },
                    "id": "8UEbg[k+}h.mkzubv9gx",
                    "type": "logic_boolean"
                  }
                }
              },
              "type": "variables_set_reserved"
            }
          },
          "IF0": {
            "block": {
              "fields": {
                "OP": "LTE"
              },
              "id": "5[kZ%s$vb~mNBclxXV@n",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "unitVariable:HpRatio"
                    },
                    "id": "=3^2vASVgHTo@a/M{16)",
                    "type": "variables_get_reserved"
                  }
                },
                "B": {
                  "block": {
                    "extraState": "<mutation></mutation>",
                    "fields": {
                      "TYPE": "caller",
                      "VAR": {
                        "id": "Eged%%SseFegShRTLt3a"
                      }
                    },
                    "id": "B;zB_UoaD!6AwzpmH$/,",
                    "type": "variables_get"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": 335,
        "y": -105
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Buff_EnableOnLowHP_Update",
    "period": "15",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": "EA)(_oC$PYNb5|Cx)i{I",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "3r?|!a!oUS[CM_8?ee:C",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "g)TX+;/vzUqvLu.~XTdY",
      "name": "Unit/Time01"
    },
    {
      "id": "}u4!YzQ7Uqjw0Bmw92)n",
      "name": "Unit/Time02"
    },
    {
      "id": ":k%94#OhQ4$7Dux*rl#m",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "HfotV~1fDjmppxvKjiFE",
      "name": "Unit/MonsterID02"
    },
    {
      "id": ";W{K#v+E7?a}cX#.tK0$",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "s|Ikn=:Ug}xD|P3A]c{,",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "j#Sti4!/%~6Dt_{%@klN",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "^NAsl#9,8JwzFqxmg1ya",
      "name": "Buff/IsInitVariables"
    },
    {
      "id": "?WTRnC~3$@JduJivK]Jo",
      "name": "Buff/CurrentWave"
    },
    {
      "id": "6)N(+-0lY)mIIAEx=esG",
      "name": "Unit/Tick"
    },
    {
      "id": "u{MP0{375]gP)*;S4Owk",
      "name": "Unit/Rome"
    },
    {
      "id": "z3qV#`kVE1k?3m~ZEBoM",
      "name": "@Unit/Delay"
    },
    {
      "id": "F6t4G=s))Lo-~c$WkcZa",
      "name": "@Unit/Range01"
    },
    {
      "id": "bE)3NKxn-;!-}TE{)pf?",
      "name": "@Unit/Range02"
    },
    {
      "id": ".A.0ZfdsyAw{.tzV}Ol;",
      "name": "@Unit/Range03"
    },
    {
      "id": "Bx|}EEB2=~rcYHO(MDUN",
      "name": "@Unit/Range04"
    },
    {
      "id": "Ygu[2NAXdvm|uz8ITG=j",
      "name": "@Unit/Range05"
    },
    {
      "id": "epVwuqEu9XHT/B9_gX2+",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "8IMeF-x7?OD~|~cKCqXd",
      "name": "@Unit/Variable01"
    },
    {
      "id": "sydI:?_j0)Nq[3x0XmA}",
      "name": "@Unit/Variable02"
    },
    {
      "id": "0TMl2qMkL!EYb[CdF9Lj",
      "name": "@Unit/Variable03"
    },
    {
      "id": "MRUh]9ojMDi(gZ;05LOo",
      "name": "@Unit/Variable04"
    },
    {
      "id": "mShJY:#dgo%f6OMU/UUQ",
      "name": "@Unit/Variable05"
    },
    {
      "id": "L0j6{cD69hhJ$$Iv+d?4",
      "name": "@Map/AddBuffToMonsterID01"
    },
    {
      "id": "nYI:o0i][_-@k^w:z.w:",
      "name": "@Map/AddBuffToMonsterID02"
    },
    {
      "id": "9gmDJ**sgnwm$tE0`9cM",
      "name": "@Map/AddBuffToMonsterID03"
    },
    {
      "id": "~`wHRU5S:=7=q_%eax!X",
      "name": "@Map/AddBuffToMonsterID04"
    },
    {
      "id": "fefh5Jd=OPHsb+J=0S(i",
      "name": "@Map/AddBuffToMonsterID05"
    },
    {
      "id": "bYY}ge]AJ}Z@$Ye{l%g(",
      "name": "@Map/AddBuffToBossID01"
    },
    {
      "id": "7)|#dLs)J4Drv73F;y[]",
      "name": "@Map/AddBuffToBossID02"
    },
    {
      "id": "f~ksLR@=]?}Aa}rgr]p=",
      "name": "@Map/AddBuffToBossID03"
    },
    {
      "id": ")*t/ct9j%p)mbU4|I(QM",
      "name": "@Map/AddBuffToBossID04"
    },
    {
      "id": "5Qwc)Z1BycO_Th.bC}.u",
      "name": "@Map/AddBuffToBossID05"
    },
    {
      "id": "q9?1$peo9-vntJx}!Xaf",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "2lz)R{xfj/Z*vK-6{Am0",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "Z]mFF78p|{9*ZjRhkOr^",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "/Vhorrrs@nf=^J)g2O0V",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "}*NSu_g%AKS!u#$h/BfK",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "1JB5W1kw;$wMe{h(@Ppj",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "a[*(n0Xeo3;,W2?l,jTw",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "qF0yP6H_VwrzI=t[au,z",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": ".9aT-$(V%vzEj@`F*o!P",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "0((`EI(AP}=X?3-MuiDi",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "F,x{YQ?C^p43$;C62MHC",
      "name": "@Map/Variable01"
    },
    {
      "id": "V1gN8,)_Bb[lx5{J_=:1",
      "name": "@Map/Variable02"
    },
    {
      "id": "Z-7e7c~:jt*-TVmZh]+6",
      "name": "@Map/Variable03"
    },
    {
      "id": "@~yf;%o`!kXZ|%nxUo*T",
      "name": "@Map/Variable04"
    },
    {
      "id": "F0FKENc)V~Z|a[9M]ShV",
      "name": "@Map/Variable05"
    },
    {
      "id": "(.MUW6{~YPPb1?Cf-JXW",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "wetp@Z_)35+P/=@}|JQj",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "!-5BM=q9d=O4P_C_.,._",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "!?o#pNd#*3Nrwx26rq]:",
      "name": "@Map/NextMapDataId"
    },
    {
      "id": "YQ}zZGQ|::|9X7c^SL7#",
      "name": "@Map/Progress"
    },
    {
      "id": "?R/7^bw#;N4A|Yp%n)qg",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "MC:c(wp[wci[.iI)/X}G",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "]=Sp;31PcTwG`jj0_}iS",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "n]pAKT^s@L-OV2;o`sPF",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "wu:HFDif.YjCDjl559_i",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "{w#PwEN:|)f,A:{]437P",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "Y|CD;WonL]*$(QuA76tl",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": ":y_1DjgslQ*0*s9dqd0j",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "xbAKZqx#{T0jOx.v{^ra",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "#!BGxFPs$`QZf~j}m.OR",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "(]j2L]^{t?:)+$q}pB-j",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "Bc6X|HSB#s96KsDc5Ih!",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": ")_Yt:cm2}NR0;r*f!+xs",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "bu0*USX$ndzfjxLP]p]@",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "n^ydMBxyRueN%R}k9IXc",
      "name": "Map/Wave"
    },
    {
      "id": "9G(MQD~k!Z8TD9;C;QJl",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "b~zmVg{@x)pizOuu%Z#X",
      "name": "Map/IsClear"
    },
    {
      "id": "^ji9Fdl0lSH:/9T!en-R",
      "name": "Map/Wave/Step"
    },
    {
      "id": "z7,1J6yy;(sTsBIg^V^K",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "NxmVOLfi=`~]gB.;d9VP",
      "name": "Map/IsSpawn"
    },
    {
      "id": "[pc|Zmn]qX7E|D~.laae",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "h,^NCUga/BO]yFiGH{bz",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": ")m,#lC(4X4}qD50v;ecg",
      "name": "Map/Wave/State"
    },
    {
      "id": "K[3%=P0U`.bYb[d%iADx",
      "name": "Map/Player/Moving"
    },
    {
      "id": "Eged%%SseFegShRTLt3a",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "(0hnS-4(6WxVQv[]Q}05",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "8e^*:adGD:xrw5gde8D9",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "^09E-Mq^:wy0lOl9[$%-",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "SklpfedM6%M+(At^=~/#",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "g1T.yPH^%-c@Kn/0n1Q_",
      "name": "@Buff/Variable/06"
    },
    {
      "id": "#].m0S(LTFTSbx-Q.5DC",
      "name": "@Buff/Variable/07"
    },
    {
      "id": "K+4yAzBZis5}w+$9miW}",
      "name": "@Buff/Variable/08"
    },
    {
      "id": "2`A)zf+`).f)5)hy*^p:",
      "name": "@Buff/Variable/09"
    },
    {
      "id": "lrMxH.).u+G7cOfj}CSD",
      "name": "@Buff/Variable/10"
    },
    {
      "id": "|#;oqtuI.U/O#dTtJ]sA",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "d8wCM;qWy./Z^P.!_W5=",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "h@W31Ngc|JuSMDv!3Lno",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "6,{FA;=Y=er|sTiDZ/K$",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "Wl:EOGvbBZ;ZPs~o`ipW",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "Nf{Uz.3Pv+!0^kUaZ]cC",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "C4`dE6Y:(5,i?Q^}[Ke_",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": ",CkV(_6kWVV%I,Q5CX:/",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "}SBy$Y~cGZePd@jx_Nnj",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "|QNb;CpI]*R^4sXb;B%{",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "^lWsh1?-EYaOHduft;Qy",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "Cgc@INWU16dbJZ8fO.2z",
      "name": "@Skill/Variable/01"
    },
    {
      "id": ";Pq.[CJoMu?lw6g?h7Cg",
      "name": "@Skill/Variable/02"
    },
    {
      "id": "UQ0;a#Tr2W-2wYF!h5Q|",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "bGv)!pJ,RpgSh0FU-sY2",
      "name": "@Skill/Variable/04"
    },
    {
      "id": "z-i}s=q?h$vpzPDN%;:s",
      "name": "@Skill/Variable/05"
    },
    {
      "id": "0L+EP~ZCaie,jr7k?xEW",
      "name": "@Skill/Variable/06"
    },
    {
      "id": "iWJessC=avD,i)t8Oty,",
      "name": "@Skill/Variable/07"
    },
    {
      "id": "d4gcZi_j{)SQjQb]PFrq",
      "name": "@Skill/Variable/08"
    },
    {
      "id": "uB_B_UQ~+Yo]z!m:=NRw",
      "name": "@Skill/Variable/09"
    },
    {
      "id": "p%K6ZcmRB[IZ.}PO/:.A",
      "name": "@Skill/Variable/10"
    },
    {
      "id": "1FXPgI870$x)mBdnpBrU",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "%O6[G)sEWd]sRGy*{A9z",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "(DICceN-%PcztOaz~Zah",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "4lX38k+C0Gl8MfI?Bn2P",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "C_6[W#ZkSu3rR+k3-{g(",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "BqvJxpT#~[.)=H`V;I-r",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "{YikS;hX^7)$lPq%|=(C",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "rnm`[XP/n1A9767fv=G1",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "A;aWuog=+~HlGVwzL^}w",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "vDPTN75Q)sF(KbfT9Hg;",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "z/+gEJ_jR,d^ANL1`op}",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "*m1LelkF4`9UMlnSQg48",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "SGMUG7u$;CnW+2qiu!v,",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "K6c`b5)VkN^q%Bf`ea;U",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "_}@BlY7#mUa]uD.ai+hE",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "owa?@B1/t)--7;|L_?W.",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "1~]b#O,v~]%1};/PULVu",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "dRtu|%3SSdJMM;?iH[W]",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "iZc2npsYr*8XX_cbZgCl",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "~ama6Ow#My%r[_gJ]Woh",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "17wJ@/_d+*]K.:oIy^ia",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "Vy?X!+DNod{[7N^,txNT",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "M)p:V{7~)[^Q{xNUL2U+",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "6trT14w!k~6/2aU+48^V",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "_r(alpj!ZKRnoF:x]$W,",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": "IlZm5Z;vMo#reqv|BYXR",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "{]@Flf^}uuI0%x@@8py#",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "r?}-h0d$-}xkLGZj+5i*",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "F1ZkLt`j4dI/4lhup#s/",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "otaw`U%78r`[W7h34DZg",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "zEO7ZF@Qh2_*U:(~UoaT",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "(K28L?OWdJ[ep2S4Ff}g",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "A]]8WKj*z%UXJErGF{~j",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "1HxNXPE3n{p_Ogdg|y-S",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "9[bjB`jlbo+PG_nzh%T7",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": ".u=#bCUT$cx7^GvKoo8V",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "h=BGl#Bb+(?7sbu#}JjP",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "[i:,h)K)kq5Q9mfwbRqz",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "5:|!n_Avm%d]mb*cSD@]",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "*Q%OF.*a4g1`4;AL]0.L",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "s%~@5qiyyX@X/t7`;`-;",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "0HsmhRP3dNbg6xVlSu/|",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": ";DO$|a.-Z$DL4#]=Nql?",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "#j/MwLzLLKCapGwBLWTo",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "m85^{{Jh??uNib$?+]*~",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "/7vJb=k(*q?[e(63XZ2~",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "$oYAJZS5v`A0VCwH9_Nu",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": ";6L/QfuMyG|(sa/PwFjr",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "!+MD{J3rbxm7a^}q}fQH",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "94fayrBBH6wAc.h`}2:D",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "}n`wD~bhmDV+G/L5Y}6d",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "=M=n{KcG8CW4X*pY2S$x",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "8+Z{]H1fRr{BwK,I9A~1",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "Xo/:QC!xO*h|9LS(b#0S",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": "V2t:LzItqnhW|Bl=YY-R",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "QiBRkFwu8$/%awo?~WMA",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "JY1i(](y!)W8!q2@0:P3",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "Vc3xZ#9=FKXr^|/nG0OA",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "EEBhrF[x]TI54Br~3=/3",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "6q:$x.wJFE[rNG.l`DTJ",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}