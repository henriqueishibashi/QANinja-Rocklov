require_relative "base_api"
# PAGE OBJECTS

class Equipos < BaseApi
  def create(payload, user_id)

    # .self.class ter acesso aos objetos da própria classe
    return self.class.post(
             "/equipos",
             # Se verificar no F12 aba network, irá verificar que o Content-Type não manda Jason.
             body: payload,
             headers: {
               # Quando usa : quer dizer que estou PASSANDO o XXXX que será recebido no metodo create como argumento.
               "user_id": user_id,
             },
           )
  end

  def booking(equipo_id, user_locator_id)
    return self.class.post(
             "/equipos/#{equipo_id}/bookings",
             # Pegando a data que foi gerado o pedido de locação, string format time (strftime)
             body: { date: Time.now.strftime("%d/%m/%Y") }.to_json,
             headers: {
               "user_id": user_locator_id,
             },
           )
  end

  def find_by_id(equipo_id, user_id)
    return self.class.get(
             "/equipos/#{equipo_id}",

             # Se observar no insomnia, tem o header e tenho que pegar o id no banco de dados, para que a rota de conexão funcione, ver a linha de /equipos/equipo id
             headers: {
               "user_id": user_id,
             },
           )
  end

  def remove_by_id(equipo_id, user_id)
    return self.class.delete(
             "/equipos/#{equipo_id}",

             # Se observar no insomnia, tem o header e tenho que pegar o id no banco de dados, para que a rota de conexão funcione, ver a linha de /equipos/equipo id
             headers: {
               "user_id": user_id,
             },
           )
  end

  def list(user_id)
    return self.class.get(
             "/equipos",

             # Se observar no insomnia, tem o header e tenho que pegar o id no banco de dados, para que a rota de conexão funcione, ver a linha de /equipos/equipo id
             headers: {
               "user_id": user_id,
             },
           )
  end
end
