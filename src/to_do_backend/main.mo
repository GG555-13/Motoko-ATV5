import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Principal "mo:base/Principal";

actor {

    type Tarefa = {
        id: Nat;
        categoria: Text;
        descricao: Text;
        urgente: Bool;
        concluida: Bool;
    };

    var idTarefa: Nat = 0;
    var tarefas: Buffer.Buffer<Tarefa> = Buffer.Buffer<Tarefa>(10);

    // Função para adicionar itens ao buffer 'tarefas'.
    public func addTarefa(desc: Text, cat: Text, urg: Bool, con: Bool): async () {
        idTarefa += 1;
        let t: Tarefa = {
            id = idTarefa;
            categoria = cat;
            descricao = desc;
            urgente = urg;
            concluida = con;
        };
        tarefas.add(t);
    };

    // Função para remover itens do buffer 'tarefas'.
    public func excluirTarefa(idExcluir: Nat): async () {
        func localizaExcluir(i: Nat, x: Tarefa): Bool {
            return x.id != idExcluir;
        };
        tarefas.filterEntries(localizaExcluir);
    };

    // Função para alterar itens do buffer 'tarefas'.
    public func alterarTarefa(idTar: Nat, cat: Text, desc: Text, urg: Bool, con: Bool): async () {
        let t: Tarefa = {
            id = idTar;
            categoria = cat;
            descricao = desc;
            urgente = urg;
            concluida = con;
        };
        func localizaIndex(x: Tarefa, y: Tarefa): Bool {
            return x.id == y.id;
        };
        let index: ?Nat = Buffer.indexOf(t, tarefas, localizaIndex);
        switch (index) {
            case (null) {
                // não foi localizado um index
            };
            case (?i) {
                tarefas.put(i, t);
            }
        };
    };

    // Função que retorna a quantidade de tarefas não concluídas (em andamento).
    public func totalTarefasEmAndamento(): async Nat {
        let tarefasArray = Buffer.toArray(tarefas);
        let tarefasEmAndamento = Array.filter(tarefasArray, func (tarefa: Tarefa): Bool {
            return not tarefa.concluida;
        });
        return Array.size(tarefasEmAndamento);
    };


    // Função que retorna a quantidade de tarefas concluídas.
    public func totalTarefasConcluidas(): async Nat {
        let tarefasArray = Buffer.toArray(tarefas);
        let tarefasConcluidas = Array.filter(tarefasArray, func (tarefa: Tarefa): Bool {
            return tarefa.concluida;
        });
        return Array.size(tarefasConcluidas);
    };

    // Função que retorna todas as tarefas do Buffer.
    public func getTarefas(): async [Tarefa] {
        return Buffer.toArray(tarefas);
    };

  public shared(message) func get_principal_client() : async Text {
    return "Principal: " # Principal.toText(message.caller) # "!";
  };
};



