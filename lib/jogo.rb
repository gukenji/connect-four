require_relative 'jogador.rb'
require_relative 'tabuleiro.rb'
require 'pry-byebug'



class Jogo
    attr_accessor :jogador1, :jogador2, :tabuleiro, :jogador_atual
    def initialize
        @jogador1 = nil
        @jogador2 = nil
        @jogador_atual = nil
        @tabuleiro = Tabuleiro.new
        @vencedor = nil
    end


    def introducao
        <<-INTRODUCAO
        Bem vindo ao jogo Connect Four!
        O objetivo deste jogo é conseguir conectar 4 bolas consecutivamente da mesma cor na horizontal, vertical ou diagonal. 
        Vence quem conseguir primeiro!
        INTRODUCAO
    end

    def jogar
        puts introducao
        criar_jogadores
        sortear_jogador
        puts "O jogador que irá comecar é o #{@jogador_atual.nome}"
        until fim_partida?
            jogada
        end
        repetir_partida
    end


    def criar_jogadores
        puts "Qual o nome deseja inserir para o primeiro jogador?"
        nome = gets.chomp.to_s
        puts "Agora me fale qual cor deseja selecionar para este jogador.\n 1: 🔵 2:🔴 "
        cor  = gets.chomp.to_i
        until checar_input(cor)
            puts "Por favor! Selecione apenas o valor 1 ou 2!"
            cor  = gets.chomp.to_i
        end
        @jogador1 = Jogador.new(nome,cor)
        puts "Qual o nome do segundo jogador?"
        nome = gets.chomp.to_s
        cor == 1 ? @jogador2 = Jogador.new(nome,2) : @jogador2 = Jogador.new(nome,1)
    end

    def checar_input(cor)
        return cor if cor == 1 || cor == 2
    end

    def sortear_jogador
        @jogador_atual = public_send("jogador#{Random.rand(1..2)}".to_sym)
    end

    def jogada
        cor = @jogador_atual.cor
        puts "Por favor #{@jogador_atual.nome}, escolha a coluna que deseja incluir seu marcador."
        coluna = gets.chomp.to_i
        until @tabuleiro.checa_espaco_coluna(coluna)
            coluna = gets.chomp.to_i
        end
        @tabuleiro.atualizar_tabuleiro(coluna,cor)
        @tabuleiro.visualizar_tabuleiro
        @jogador_atual == @jogador1 ? @jogador_atual = @jogador2 : @jogador_atual = @jogador1
    end

    def checar_colunas
        resultado = false
        for i in 1..7
            array = @tabuleiro.public_send("coluna#{i}".to_sym)
            for j in 0..2 do
                cutted_array = array[j..j+3]
                resultado = cutted_array.each_cons(2).all? { |a,b| b == a unless a == nil }
                break if resultado == true
            end
            break if resultado == true
        end
        resultado
    end

    def checar_linhas
        resultado = false
        array = @tabuleiro.tabuleiro
        for i in 0..5 #linha
            for j in 0..3 do #coluna
                cutted_array = []
                cutted_array << array[j][i]
                cutted_array << array[j+1][i]
                cutted_array << array[j+2][i]
                cutted_array << array[j+3][i]
                cutted_array.length == 4 ? resultado = cutted_array.each_cons(2).all? { |a,b| a == b unless a == nil } : next
                break if resultado == true
            end
            break if resultado == true
        end
        resultado
    end

    def checar_diagonal_1
        resultado = false
        array = @tabuleiro.tabuleiro
        for i in 0..3 #coluna
            for j in 0..2 #linha
                cutted_array = []
                cutted_array << array[j][i]
                cutted_array << array[j+1][i+1]
                cutted_array << array[j+2][i+2]
                cutted_array << array[j+3][i+3]
                cutted_array.length == 4 ? resultado = cutted_array.each_cons(2).all? { |a,b| a == b unless a == nil } : next
                break if resultado == true
            end
            break if resultado == true
        end
        resultado
    end

    def checar_diagonal_2
        resultado = false
        array = @tabuleiro.tabuleiro
        for i in 0..3 #coluna
            for j in 3..5 #linha
                cutted_array = []
                cutted_array << array[j][i]
                cutted_array << array[j-1][i+1]
                cutted_array << array[j-2][i+2]
                cutted_array << array[j-3][i+3]
                cutted_array.length == 4 ? resultado = cutted_array.each_cons(2).all? { |a,b| a == b unless a == nil } : next
                break if resultado == true
            end
            break if resultado == true
        end
        resultado
    end



    def fim_partida?
        if checar_colunas || checar_linhas || checar_diagonal_1 || checar_diagonal_2
            @jogador_atual == jogador1 ? @vencedor = jogador2 : @vencedor = jogador1
            puts "Parabéns #{@vencedor.nome}!"
            return true
        end
    end 

    def repetir_partida
        puts "Gostaria de jogar novamente? Digite S ou N"
        option = gets.chomp.downcase
        until option == "s" || option == "n"
            puts "Escolha apenas S ou N!"
            option = gets.chomp.downcase
        end
        option == "s" ? Jogo.new.jogar : puts("Obrigado por jogar!")
    end
end


