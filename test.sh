#!/bin/bash
#
curl -d '{"board_size":19, "moves":["R4", "D16"]}' -H "Content-Type: application/json" -X POST http://127.0.0.1:2178/select-move/katago_gtp_bot
#curl -d '{"board_size":19, "moves":["R4", "D16", "D17","Q10","Q12","C15"]}' -H "Content-Type: application/json" -X POST http://127.0.0.1:2178/score/katago_gtp_bot

