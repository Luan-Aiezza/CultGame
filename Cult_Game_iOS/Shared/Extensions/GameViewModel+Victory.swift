//
//  GameViewModel+Victory.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 01/06/25.
//

import SwiftUI
import os

private let logger = Logger(subsystem: "mooncat.Cult-Game-iOS", category: "GameLogic")

extension GameViewModel {
    
    @objc func handleVictory(_ notification: Notification) {
        if let outcome = notification.object as? GameOutcome {
            self.gameOutcome = outcome
            self.currentPhase = .victory(outcome)
            multiplayerManager.sendGamePhase(.victory(outcome))
        }
    }
    
    func evaluateVictory() {
        logger.debug("connected peers: \(self.multiplayerManager.connectedPeers)")
        
        let players = multiplayerManager.players
        logger.debug("jogadores: \(players)")
        
        let cultists = players.filter { (_, player) in
            if let role = player.role {
                return role == .cultist && player.state == .active
            } else {
                return false
            }
        }
        logger.debug("cultistas ativos: \(cultists.map { $0.key })")
        
        let heretics = players.filter { (_, player) in
            if let role = player.role {
                return role == .heretic && player.state == .active
            } else {
                return false
            }
        }
        logger.debug("hereges ativos: \(heretics.map { $0.key })")
        
        var outcome: GameOutcome?
        
        let followers = multiplayerManager.globalState.followers
        logger.debug("seguidores: \(followers)")
        
        if followers >= GameRules.maxFollowers {
            logger.info("vitória dos cultistas por número de seguidores")
            outcome = .cultistVictoryFollowers
        } else if heretics.isEmpty {
            logger.info("nenhum herege ativo restante.")
            if let eliminatedPeer = self.eliminatedPlayer {
                logger.debug("jogador eliminado: \(eliminatedPeer)")
                if let eliminated = players[eliminatedPeer] {
                    logger.debug("rle eliminado: \(eliminated.role?.rawValue ?? "desconhecido")")
                    if eliminated.role == .heretic {
                        logger.info("vitória dos cultistas por eliminação de herege")
                        outcome = .cultistVictoryElimination
                    }
                }
            }
        } else if followers <= 0 {
            logger.info("vitória dos hereges por perda total de seguidores!")
            outcome = .hereticVictoryFollowers
        } else if heretics.count >= cultists.count {
            logger.info("vitória dos hereges por balanceamento!")
            outcome = .hereticVictoryBalance
        }
        
        let activePlayers = players.filter { (_, player) in
            player.state == .active
        }
        logger.debug("jogadores ativos restantes: \(activePlayers.count)")
        
        if activePlayers.count >= 3 && outcome == nil {
            logger.info("continuando para próxima fase: roleSelection")
            advancePhaseAfterTimer()
        }
        
        if let outcome {
            logger.info("vitória detectada: \(String(describing: outcome))")
            multiplayerManager.sendVictory(outcome)
            self.gameOutcome = outcome
            multiplayerManager.currentPhase = .victory(outcome)
            multiplayerManager.sendGamePhase(.victory(outcome))
        } else {
            logger.info("nenhuma vitória detectada — avançando fase")
            //advancePhaseAfterTimer()
        }
        
        logger.debug("fim de evaluateVictory()")
    }
}
