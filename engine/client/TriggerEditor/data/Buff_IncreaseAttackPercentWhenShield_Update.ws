{
  "blocks": {
    "blocks": [
      {
        "extraState": {
          "hasElse": true
        },
        "id": "p=%z+*9IsWq?L?;H(S$B",
        "inputs": {
          "DO0": {
            "block": {
              "fields": {
                "THIS": true,
                "VAR": "buffVariable:Enabled"
              },
              "id": "^3w00NI9,^S8#q%+h+nB",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "BOOL": "TRUE"
                    },
                    "id": "-JVgOrO^[*+,DYfY8:}|",
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
              "id": "8?!c{0MX3lE2^ILh`uIW",
              "inputs": {
                "VALUE": {
                  "block": {
                    "fields": {
                      "BOOL": "FALSE"
                    },
                    "id": "JQeB:._82Hk*?gOA}o9I",
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
                "OP": "GT"
              },
              "id": "a7;l]830|602uY+mBAAk",
              "inputs": {
                "A": {
                  "block": {
                    "fields": {
                      "THIS": true,
                      "VAR": "unitVariable:Shield"
                    },
                    "id": "sYSt%]x1:~?D02lw)%BB",
                    "type": "variables_get_reserved"
                  }
                },
                "B": {
                  "block": {
                    "fields": {
                      "NUM": 0
                    },
                    "id": "GayOFfX+AjB*k,Ozs@{-",
                    "type": "math_number"
                  }
                }
              },
              "type": "logic_compare"
            }
          }
        },
        "type": "controls_if",
        "x": 695,
        "y": 115
      }
    ],
    "languageVersion": 0
  },
  "metadata": {
    "name": "Buff_IncreaseAttackPercentWhenShield_Update",
    "period": "15",
    "triggerType": "1"
  },
  "scroll": {},
  "variables": [
    {
      "id": "#GhD+B86O-s=[KE;KF/t",
      "name": "Gem"
    },
    {
      "id": "m*:EP+dF8PaEKXGLzsNh",
      "name": "Map/IsInitVariables"
    },
    {
      "id": "kh+ZVe{%/N]u|ei#^EW7",
      "name": "Unit/IsInitVariables"
    },
    {
      "id": "^X]50!sjf(!P;;,a?]H}",
      "name": "Unit/Time01"
    },
    {
      "id": "[+,jDBNvQ^hc*uD2F^L{",
      "name": "Unit/Time02"
    },
    {
      "id": "peB|25K;ZA}H0~0-`~+H",
      "name": "Unit/MonsterID01"
    },
    {
      "id": "fS5p{[)cDCoIo0G]=L-P",
      "name": "Unit/MonsterID02"
    },
    {
      "id": "cFN$}Eld40`zg_91k]IC",
      "name": "Unit/MonsterID03"
    },
    {
      "id": "YXCbu?h1ec7@2{@~nY4)",
      "name": "Unit/StartPlayerPosition"
    },
    {
      "id": "+si8B);aK%F$ga%:py4D",
      "name": "Unit/OnPlayPosition"
    },
    {
      "id": "(9*AG2*Ml@9qMSoR_RWo",
      "name": "Unit/Tick"
    },
    {
      "id": ";y9/1^Of72jDi)k!7q5n",
      "name": "Unit/Rome"
    },
    {
      "id": "3iahS|0g;i=#l5Hm@~Ih",
      "name": "@Unit/Delay"
    },
    {
      "id": "j3tNv.`MImp@~z:=.W,-",
      "name": "@Unit/Range01"
    },
    {
      "id": "~Kx7J8[Ik!!Hz*r9h4Z|",
      "name": "@Unit/Range02"
    },
    {
      "id": "OYabekt%pA{]~8iZK:za",
      "name": "@Unit/Range03"
    },
    {
      "id": "OK2~=`%u0LzwNyD0yJwa",
      "name": "@Unit/Range04"
    },
    {
      "id": "|-FU*p1ZSy0]2.y}6EbM",
      "name": "@Unit/Range05"
    },
    {
      "id": "~Zi:0@((|%=JiS:#S5|a",
      "name": "@Unit/AddInitBuffID"
    },
    {
      "id": "KHf4hO~EXmA@R)r6J(2%",
      "name": "@Unit/Variable01"
    },
    {
      "id": "01kRYwP^8rD4(Gf{fseh",
      "name": "@Unit/Variable02"
    },
    {
      "id": "yz:_2R5l-y4nOV+H~e-#",
      "name": "@Unit/Variable03"
    },
    {
      "id": "_:K{D(13SUhlRE`Pg=dQ",
      "name": "@Unit/Variable04"
    },
    {
      "id": "~F@OXk3w]-35DOn}9tnY",
      "name": "@Unit/Variable05"
    },
    {
      "id": ":XF/A@2%YDe3OI$s!OIE",
      "name": "@Unit/DefaultSkillID/01"
    },
    {
      "id": "I2sIJeCM*5HTW$G]9?3B",
      "name": "@Unit/DefaultSkillID/02"
    },
    {
      "id": "d]5+y!1Y?}Y9,;-p%J^P",
      "name": "@Unit/DefaultSkillID/03"
    },
    {
      "id": "m~!%V1E49+Y({yAbCl^N",
      "name": "@Unit/DefaultSkillID/04"
    },
    {
      "id": "h+4lZc(Ha-YHI@8X}y5t",
      "name": "@Unit/DefaultSkillID/05"
    },
    {
      "id": "I!)6Q,$1#sX@.RKk__j-",
      "name": "@Unit/SkillType/01"
    },
    {
      "id": "[[3dd3|9anLR=.WADrg/",
      "name": "@Unit/SkillType/02"
    },
    {
      "id": "#rL4B9d+`WD2_b{gRk)7",
      "name": "@Unit/SkillType/03"
    },
    {
      "id": "dv!ZH3wT;3gBho|K%#9c",
      "name": "@Unit/SkillType/04"
    },
    {
      "id": "q~%|tz(DG,B@bF|c]I}{",
      "name": "@Unit/SkillType/05"
    },
    {
      "id": "[P1cPUu=!-[}w5-|K.uz",
      "name": "@Map/Variable01"
    },
    {
      "id": "Mn1a+c;b[Q0yqYSe3*k(",
      "name": "@Map/Variable02"
    },
    {
      "id": "RM:Ot$^J8{B|qMq*VJ6=",
      "name": "@Map/Variable03"
    },
    {
      "id": "mBb!58DfS5BI_yYP@[}7",
      "name": "@Map/Variable04"
    },
    {
      "id": "F^sUyXJx;fbLjhB@j2oo",
      "name": "@Map/Variable05"
    },
    {
      "id": "Jr}#gCzORA)M#q/J.k+f",
      "name": "@Map/MidBossSpawn"
    },
    {
      "id": "YT]Ka78=Ei4C}C8g7`S+",
      "name": "@Map/FinalBossSpawn"
    },
    {
      "id": "|O5:Ua:?%*}c(;G#VVT8",
      "name": "@Unit/ChargeSkillID/01"
    },
    {
      "id": "zpRnSp|.KC896jK(wy:x",
      "name": "@Map/Encounter/Step"
    },
    {
      "id": "{R6q8*#zZ[DA$HZzqAdU",
      "name": "@Map/Encounter/LevelUpTraitCount"
    },
    {
      "id": "A0pWhf)uUq{(nnves{1r",
      "name": "@Map/Encounter/WaveEndTraitCount"
    },
    {
      "id": "h1a(_u}4Y2BP}2tyG-tC",
      "name": "@Map/WaveAchID00"
    },
    {
      "id": "Z$G%/#YUGawkql,1Uo=G",
      "name": "@Map/WaveAchID01"
    },
    {
      "id": "{?B-vE7Jr|MOFUb6k5A*",
      "name": "@Map/WaveAchID02"
    },
    {
      "id": "T9iNu1Vg2lc[$Z_5SSL[",
      "name": "@Map/WaveAchID03"
    },
    {
      "id": "ln/Wy*whytHqJn9S.e,k",
      "name": "@Map/WaveAchID04"
    },
    {
      "id": "B1N$]oY}aVM9|Oi)UUE?",
      "name": "@Map/WaveAchID05"
    },
    {
      "id": "O4)GjN5EfgRXaAsKBlgE",
      "name": "@Map/WaveAchID06"
    },
    {
      "id": "7L0foYB#E]F*lPn?jf9z",
      "name": "@Map/WaveAchID07"
    },
    {
      "id": "]3UsMW#J9#(la%yZd3*v",
      "name": "@Map/WaveAchID08"
    },
    {
      "id": "UO}%r5;YbC+1tGnl.WD:",
      "name": "@Map/WaveAchID09"
    },
    {
      "id": "G4A?v0]iN=Tv52KgWAl+",
      "name": "@Map/WaveAchID10"
    },
    {
      "id": "`OUY]TOy*lDU!E/QV;[i",
      "name": "Map/Wave"
    },
    {
      "id": "8YX6#ul2sOrq9NIVYKEW",
      "name": "Map/Wave/StringId"
    },
    {
      "id": "lW_DjE4RiDh{a5D%:Sir",
      "name": "Map/IsClear"
    },
    {
      "id": "{]STxY^z6Ij-%ysAzj;)",
      "name": "Map/Wave/Step"
    },
    {
      "id": "dKCakQ146ggDZ)wMdNI{",
      "name": "Map/Wave/Step/Tick"
    },
    {
      "id": "bgnhRH?Bb$h(9Ny!7zpY",
      "name": "Map/IsSpawn"
    },
    {
      "id": "^Ws_gyScM~qNXZTH!;0S",
      "name": "Map/Wave/StartTick"
    },
    {
      "id": "bKHQ5tB`dpuf}fL^Q`9W",
      "name": "Map/Wave/EndTick"
    },
    {
      "id": "(PD(kV6yY[kU}2E,;7d?",
      "name": "Map/Wave/State"
    },
    {
      "id": "`2@7U9Gn@|UJMN:*{y7w",
      "name": "Map/Player/Moving"
    },
    {
      "id": "Y||sEpqP`)d8hN!O7Ez(",
      "name": "@Buff/Variable/01"
    },
    {
      "id": "$fjWun,aWiaGO(:9RmR7",
      "name": "@Buff/Variable/02"
    },
    {
      "id": "-#DLGeIyDmgs{#4EHYiF",
      "name": "@Buff/Variable/03"
    },
    {
      "id": "VUM^LOKrH]pFez_lE5]e",
      "name": "@Buff/Variable/04"
    },
    {
      "id": "2:{.$0M)Z|lscX`fr]QD",
      "name": "@Buff/Variable/05"
    },
    {
      "id": "4ZQ1u:Rswc(^ZAht,s@W",
      "name": "@Buff/Variable/06"
    },
    {
      "id": ".q2N=?8;,L=5zGE/V_A=",
      "name": "@Unit/Type/Armor/Normal"
    },
    {
      "id": "06i3`$qGRO{|CFI]eb_U",
      "name": "@Unit/Type/Armor/Light"
    },
    {
      "id": "G/}M@,?GnjM}.[oz%lO%",
      "name": "@Unit/Type/Armor/Heavy"
    },
    {
      "id": "p3:MKPXyC6)v(Gh+kE]C",
      "name": "Skill/TIMELINE_DAMAGE_001"
    },
    {
      "id": "u9Vw@.y3-CtcNyh@wX}h",
      "name": "Skill/TIMELINE_DAMAGE_002"
    },
    {
      "id": "Hu3#[-${Q`z^O9=$J/~g",
      "name": "Skill/TIMELINE_DAMAGE_003"
    },
    {
      "id": "/vLhmM.J|V{U3D6n[T|W",
      "name": "Skill/TIMELINE_DAMAGE_004"
    },
    {
      "id": "$,dwH8ToE)A$P.T*PrY_",
      "name": "Skill/TIMELINE_HEAL_001"
    },
    {
      "id": "aM8H$H(dU:W(r+Ps7HL0",
      "name": "Skill/TIMELINE_HEAL_002"
    },
    {
      "id": "KycYULkO`X/}e1GM^7pu",
      "name": "Skill/TIMELINE_HEAL_003"
    },
    {
      "id": "@m*~s*#ZS[iT9RwIUq!x",
      "name": "Skill/TIMELINE_HEAL_004"
    },
    {
      "id": "PrE|0v$7L%DfKu*SaRyT",
      "name": "@Skill/Variable/01"
    },
    {
      "id": "9bI`sj0MvNj/x)Iy{O5m",
      "name": "@Skill/Variable/02"
    },
    {
      "id": ":z/9z?7.=Z/T]pvIF=.-",
      "name": "@Skill/Variable/03"
    },
    {
      "id": "c`9[{dm/6jFcLZm@[]:p",
      "name": "@Skill/Trait/BlastCount"
    },
    {
      "id": "!@i-YnHarauSvO1[lg1I",
      "name": "@Skill/Trait/Blast"
    },
    {
      "id": "6B1VH{%A;DS9M?wUq_cT",
      "name": "@Skill/Trait/Feast"
    },
    {
      "id": "(+f2lyzC[8mne{z(/_$e",
      "name": "@Skill/Trait/ResetOnKill"
    },
    {
      "id": "Jl;=CBt~,:aWn^d+bVkS",
      "name": "@Map/Wave1/Monster1"
    },
    {
      "id": "dR,n(!{jvy^!nVaG#J|n",
      "name": "@Map/Wave1/Monster2"
    },
    {
      "id": "84U!fEvT+y@C+:[)Jw!G",
      "name": "@Map/Wave1/Monster3"
    },
    {
      "id": "f;Fic8W0@#M;Q_|r=D`G",
      "name": "@Map/Wave1/Monster4"
    },
    {
      "id": "`v@?Zw#~lvsmQ5WWM/AQ",
      "name": "@Map/Wave1/Monster5"
    },
    {
      "id": "D~o-V3(pwX=hBD,4a%nn",
      "name": "@Map/Wave1/Monster6"
    },
    {
      "id": "N[s:wh6=,7m))F]RB?_T",
      "name": "@Map/Wave1/Monster7"
    },
    {
      "id": "YE-roJd2PJ9GJ-mVXdTv",
      "name": "@Map/Wave1/Monster8"
    },
    {
      "id": "o-oD;[]7Mc8^NMJ8;I;.",
      "name": "@Map/Wave1/Monster9"
    },
    {
      "id": "Z9*w|/MGRy]Z=N.[rlrx",
      "name": "@Map/Wave1/Monster10"
    },
    {
      "id": "{:)TkQcFh@`VhNeAy)LU",
      "name": "@Map/Wave2/Monster1"
    },
    {
      "id": "pNDv^MP}ap9Emqmqx*vD",
      "name": "@Map/Wave2/Monster2"
    },
    {
      "id": "9~-Fn2]U5CAni~K3xChH",
      "name": "@Map/Wave2/Monster3"
    },
    {
      "id": "6aNnWY;+}1ZV~-D7.]Y9",
      "name": "@Map/Wave2/Monster4"
    },
    {
      "id": "ym3mm`-?~TZ{O|(mv;Kg",
      "name": "@Map/Wave2/Monster5"
    },
    {
      "id": "N93$m^%zQoK]*}F}-=UQ",
      "name": "@Map/Wave2/Monster6"
    },
    {
      "id": "mf8?]GExdzKnZdMiH#[o",
      "name": "@Map/Wave2/Monster7"
    },
    {
      "id": "vvQqB0.zErdler[7%7U4",
      "name": "@Map/Wave2/Monster8"
    },
    {
      "id": "y_QXRG57W%e[Kx7J(bm7",
      "name": "@Map/Wave2/Monster9"
    },
    {
      "id": "MJFxkw;`LAQ/gckne(O;",
      "name": "@Map/Wave2/Monster10"
    },
    {
      "id": "QEJtZ*WrssnyDL4rv`Vk",
      "name": "@Map/Wave3/Monster1"
    },
    {
      "id": ";ai25d+Y5|E=)c.MhM0T",
      "name": "@Map/Wave3/Monster2"
    },
    {
      "id": "a#A71YsUD34x6JAr=Wn@",
      "name": "@Map/Wave3/Monster3"
    },
    {
      "id": "Vtybe.^CZf4dckGUy`Sz",
      "name": "@Map/Wave3/Monster4"
    },
    {
      "id": "Lxem-gV]|WhR=#iTpFju",
      "name": "@Map/Wave3/Monster5"
    },
    {
      "id": "uW_Hw;zE%RHl%A,se61:",
      "name": "@Map/Wave3/Monster6"
    },
    {
      "id": "=`vSV?3L+%*3$Ph5djg=",
      "name": "@Map/Wave3/Monster7"
    },
    {
      "id": "CH80ejNgL:lmYarEuNi(",
      "name": "@Map/Wave3/Monster8"
    },
    {
      "id": "1N|tgniYAtSe|K@xS$9)",
      "name": "@Map/Wave3/Monster9"
    },
    {
      "id": "=yx9r7^;X#maw{Q~}jgZ",
      "name": "@Map/Wave3/Monster10"
    },
    {
      "id": "kPlZYS]h7p3rGdk4]Yw!",
      "name": "@Map/Wave4/Monster1"
    },
    {
      "id": "+F%ezF$rb;*wMV[VI_@i",
      "name": "@Map/Wave4/Monster2"
    },
    {
      "id": "bcqjJzrw)Rc3Nv}(8J,I",
      "name": "@Map/Wave4/Monster3"
    },
    {
      "id": "%%@)|~T./]_(02tP70q`",
      "name": "@Map/Wave4/Monster4"
    },
    {
      "id": "Dfi1`of/FX~d:[%Cz8E0",
      "name": "@Map/Wave4/Monster5"
    },
    {
      "id": "y/)puRv|;C*7rbOTSX*S",
      "name": "@Map/Wave4/Monster6"
    },
    {
      "id": "$9#]|m;Cu80gej(2qRL7",
      "name": "@Map/Wave4/Monster7"
    },
    {
      "id": "-#5khYESVF,fq.R2TIPF",
      "name": "@Map/Wave4/Monster8"
    },
    {
      "id": "J(#nM%@0,QYu8+oZ}Bb]",
      "name": "@Map/Wave4/Monster9"
    },
    {
      "id": "%kE~*e~`wi/jg:G.@@JT",
      "name": "@Map/Wave4/Monster10"
    },
    {
      "id": "C[gd-t$S{,XA$xK4Wqn:",
      "name": "@Map/Wave5/Monster1"
    },
    {
      "id": "RFUlZ7KaC7Uz9::@Ow7I",
      "name": "@Map/Wave5/Monster2"
    },
    {
      "id": "leA8t8i~DOY^lt#6SQ#n",
      "name": "@Map/Wave5/Monster3"
    },
    {
      "id": "gg#Uh9_0(9!Y?WLazfM7",
      "name": "@Map/Wave5/Monster4"
    },
    {
      "id": "8:A@:.D.=nkJ]x;Fbz?I",
      "name": "@Map/Wave5/Monster5"
    },
    {
      "id": "t-u@l#`+KV8_|DWG;Qr9",
      "name": "@Map/Wave5/Monster6"
    },
    {
      "id": "uFigGo$0;Tkeuq9$=Xu:",
      "name": "@Map/Wave5/Monster7"
    },
    {
      "id": "N{O*Vy2Soeh}koMwAx:T",
      "name": "@Map/Wave5/Monster8"
    },
    {
      "id": "b7{JljkF}7XmtcP*-{/o",
      "name": "@Map/Wave5/Monster9"
    },
    {
      "id": "jj}s%0P/B_7g30pg}HZ$",
      "name": "@Map/Wave5/Monster10"
    },
    {
      "id": ",Piq$.16ppi_~C^@0Eri",
      "name": "@Map/Player/InitBuff1"
    },
    {
      "id": "GE0u6*WQCIa%$~x_,%,!",
      "name": "@Map/Player/InitBuff2"
    },
    {
      "id": "i5mvM*GQE[LO`x-AQHQe",
      "name": "@Map/Player/InitBuff3"
    },
    {
      "id": "P)13+SXA#h[6}8hmd-{~",
      "name": "@Map/Player/InitUseSkill1"
    },
    {
      "id": "OnUO)401J$M,kUlq4!)E",
      "name": "@Map/Player/InitUseSkill2"
    },
    {
      "id": "1#8Qff86YF`y!LQ^N{%{",
      "name": "@Map/Player/InitUseSkill3"
    }
  ]
}