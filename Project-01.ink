VAR shot_inside = 0
VAR shot_outside = 0
VAR defense = 0
VAR rebounding = 0
VAR availpoints = 5

VAR has_basketball = 0

VAR points = 0
VAR assists = 0
VAR shots = 0
VAR makes = 0
VAR rebounds = 0

VAR team_score = 0
VAR opp_score = 0

VAR quarter = 1
VAR time = 0
VAR quarter_adv = 0

-> start

== start ==
Welcome to Basketball Simulator
 * [Start] -> character_creation
 
== character_creation ==
Available Points = {availpoints}
 + {availpoints > 0} [Upgrade Inside Shot: {shot_inside}] {increase_shot_inside()} -> character_creation
 + {availpoints > 0} [Upgrade Outside Shot: {shot_outside}] {increase_shot_outside()} -> character_creation
 + {availpoints > 0} [Upgrade Defense: {defense}] {increase_defense()} -> character_creation
 + {availpoints > 0} [Upgrade Rebounding: {rebounding}] {increase_rebounding()} -> character_creation
 * {availpoints == 0} [Done] -> court_back
 
=== function increase_shot_inside
 ~ shot_inside += 1
 ~ availpoints -= 1
 === function increase_shot_outside
 ~ shot_outside += 1
 ~ availpoints -= 1
 === function increase_defense
 ~ defense += 1
 ~ availpoints -= 1
 === function increase_rebounding
 ~ rebounding += 1
 ~ availpoints -= 1

== court_back ==
~ quarter_adv = time_advance()
{ quarter_adv == 1:
 -> court_back
 }
 { quarter_adv == 2:
  -> game_end
 }
 
You're at the back of the court. {has_basketball: In your hands is the basketball.} What will you do?
 + [Move Up] -> court_back_mid
 + {not has_basketball} [Call for basketball] -> basketball_called_for(-> court_back)
 + {has_basketball} [Pass basketball] -> pass_ball
 + [Stats] -> view_stats(->court_back)

== court_back_mid ==
~ quarter_adv = time_advance()
{ quarter_adv == 1:
 -> court_back
 }
 { quarter_adv == 2:
  -> game_end
 }
You're at the back-middle of the court. {has_basketball: In your hands is the basketball.} What will you do?
 + [Move Up] -> court_front_mid
 + {not has_basketball} [Call for basketball] -> basketball_called_for(-> court_back_mid)
 + {has_basketball} [Pass basketball] -> pass_ball
 + [Stats] -> view_stats(->court_back_mid)

== court_front_mid ==
~ quarter_adv = time_advance()
{ quarter_adv == 1:
 -> court_back
 }
 { quarter_adv == 2:
  -> game_end
 }
You're at the front-middle of the court. {has_basketball: In your hands is the basketball.} What will you do?
 + [Move Up] -> court_front
 + {not has_basketball} [Call for basketball] -> basketball_called_for(-> court_front_mid)
 + {has_basketball} [Pass basketball] -> pass_ball
 + {has_basketball} [Attempt 3-Point Shot] -> basketball_shot(1)
 + [Stats] -> view_stats(->court_front_mid)

== court_front ==
~ quarter_adv = time_advance()
{ quarter_adv == 1:
 -> court_back
 }
 { quarter_adv == 2:
  -> game_end
 }
You're at the back-middle of the court. {has_basketball: In your hands is the basketball.} What will you do?
 + [Move Back] -> court_front_mid
 + {not has_basketball} [Call for basketball] -> basketball_called_for(-> court_front)
 + {has_basketball} [Pass basketball] -> pass_ball
 + {has_basketball} [Attempt 2-Point Shot] -> basketball_shot(0)
 + [Stats] -> view_stats(->court_front)
 
 
 == game_end ==
 After the game you head over to your press conference.
 + [Continue] -> press_conference
 
 == press_conference ==
 { opp_score > team_score:
  The conference begins with discussion about the loss.
  - else:
  The conference begins with a reporter congratulating you on the win.
  }
  { points > 10:
  Your impressive scoring is noticed.
  - else :
  A reporter mentions your lack of scoring.
  }
  { assists > 3:
  You're congratulated for being a team player
  - else:
  A reporter calls you a ball hog.
  }
  { rebounds > 2:
  Your ferocity at the glass doesn't go unnoticed.
  - else:
  Your lack of rebounding is mentioned.
  }
 + [Continue] -> end_game_stats
 
 == end_game_stats == 
 Your final stats: 
 Points: {points}
 Rebounds: {rebounds}
 Shots: {shots}
 Assists: {assists}
 + [Continue] -> end_screen
 
 
 == end_screen == 
 You head back home from the stadium. Having finished your first career game, you dream about what the future has in store for you.
 -> END
 
 == view_stats(->x) ==
 ~ time -= 1
 Points: {points}
 Rebounds: {rebounds}
 Shots: {shots}
 Assists: {assists}
 
 + [Return] -> x
 
 == opp_turn ==
 ~ temp chance = RANDOM(1, 7)
 The opponent team has the ball.
 { chance > defense:
  { chance > defense+2:
  The opponent team makes a 3 pointer.
  ~ opp_score += 3
  - else:
  The opponent team makes a 2 pointer.
  ~opp_score += 2
  }
  - else:
  The opponent team fails to make a shot.
  }
  + [Change of possession] -> court_back
 
 == pass_ball ==
 ~ temp chance = RANDOM(1, 10)
 ~ has_basketball = 0
 You pass the ball to a teammate.
 {chance < 3:
  + [The ball is stolen] -> opp_turn
  - else:
   { chance < 5:
    + [Your teammate misses] -> opp_turn
    - else:
     { chance < 9:
     ~ team_score += 2
     ~ assists += 1
      + [Your teammate scores 2 points] -> opp_turn
      - else:
     ~ team_score += 3
     ~ assists += 1
       + [Your teammate scores 3 points] -> opp_turn
      }
     }
    }
       
 
 == basketball_called_for(->x) ==
 ~ temp chance = RANDOM(1, 10)
 { chance == 1:
    The basketball is stolen!
    + [Change of possession] -> opp_turn
 }
 
 {  chance > 3:
        The basketball is passed to you.
        ~ has_basketball = 1
        + [Catch the basketball] -> x
        
    - else:
        You're ignored by your teammate.
        + [Resume playing] -> x
 }
 
 == basketball_shot(inout) ==
 ~ temp chance = RANDOM(0, 6)
 ~ shots += 1
 { inout == 0:
    { chance < shot_inside + 1:
        You make the shot.
        ~ points += 2
        ~ team_score += 2
        ~ makes += 1
        ~ has_basketball = 0
        + [Move back to defense] -> opp_turn
    - else:
        You miss the shot
        + [Attempt Rebound] -> rebound_attempt
    }
  - else:
    { chance < shot_outside + 1:
        You make the shot.
        ~ points += 3
        ~ team_score += 3
        ~ makes += 1
        ~ has_basketball = 0
        + [Move back to defense] -> opp_turn
    - else:
        You miss the shot
        ~ has_basketball = 0
        + [Move back to defense] -> opp_turn
    }
}

== rebound_attempt ==
 ~ temp chance = RANDOM(0, 6)
 { chance < rebounding + 1:
    You get the rebound.
    ~ rebounds += 1
    + [Continue] -> court_front
   - else:
    You don't get the rebound.
    ~ has_basketball = 0
    + [Move back to defense] -> opp_turn
  }
    
== function time_advance ==
 ~ time += 1
 { time > 10:
  ~ time = 0
  ~ quarter += 1
  ~ quarter_adv = 1
  { quarter > 4:
   The final buzzer sounds.
   ~ return 2
   - else:
   The buzzer sounds, the quarter has ended.
   ~ return 1
   }
  - else:
    It is Quarter {quarter} with {11-time} minutes remaining.
    The score is {opp_score} to {team_score}
    ~ return 0
  }

 
    
            
        
    
 