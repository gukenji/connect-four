require 'pry-byebug'

class Tabuleiro
    attr_accessor :tabuleiro, :coluna1, :coluna2, :coluna3, :coluna4, :coluna5, :coluna6, :coluna7
    def initialize
        @coluna1 = Array.new(6)
        @coluna2 = Array.new(6)
        @coluna3 = Array.new(6)
        @coluna4 = Array.new(6)
        @coluna5 = Array.new(6)
        @coluna6 = Array.new(6)
        @coluna7 = Array.new(6)
        @tabuleiro = [@coluna1,
                      @coluna2,
                      @coluna3,
                      @coluna4,
                      @coluna5,
                      @coluna6,
                      @coluna7]
    end

    def checa_espaco_coluna(coluna)
        return puts ("Escolha uma coluna de 1 até 7!") if coluna < 1 || coluna > 7
        attr = public_send("coluna#{coluna}".to_sym)
        attr.all? ? puts("Coluna cheia! Escolha outra coluna.") : true
    end

    def retorna_proximo_espaco(coluna)
        index = nil
        attr = public_send("coluna#{coluna}".to_sym)
        attr.each_with_index do |v,i|
            if v == nil
                index = i
                break
            else
                next
            end
        end
        index
    end


    def atualizar_tabuleiro(coluna,cor) 
        attr = public_send("coluna#{coluna}".to_sym)
        checa_espaco_coluna(coluna) ? attr[retorna_proximo_espaco(coluna)] = cor : puts("Sem espaço!")
    end


    def visualizar_tabuleiro
        # Code smells: length -2 -> Deveria pegar length da coluna, nao do tabuleiro.
        (tabuleiro.length-2).downto(0) do |i|
            0.upto(tabuleiro[i].length) do |j|
                if j != tabuleiro[i].length
                    cores(tabuleiro[j][i])
                else
                    cores(tabuleiro[j][i])
                    puts ""
                end
            end
        end
    end

    def cores(num)
        if num == 1
            print "🔵 "
        elsif num == 2
            print "🔴 "
        else
            print "⚪ "
        end
    end
end
