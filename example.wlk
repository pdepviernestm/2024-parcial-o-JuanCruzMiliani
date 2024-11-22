//-----------------------------------------------------------
//PERSONAS
//-----------------------------------------------------------
class GrupoDePersonas {
    const property personas = #{}

    method vivirEventoJuntos(evento) {
        personas.forEach({persona => persona.viviUnEvento(evento)})
    } 
}

class Persona {
    const property edad
    const property emociones = #{} 

    method esAdolescente() 
        = self.edad().between(12, 19)

    method nuevaEmocion(emocion){
        emociones.add(emocion)
    }
         
    method estaPorExplotar() 
        = emociones.all({emocion => emocion.puedeLiberarse()})

    method viviUnEvento(evento) 
        = evento.vivirEvento(self)
}
//-----------------------------------------------------------
//EMOCIONES
//-----------------------------------------------------------
class Emocion {    
    var property intensidad
    var property liberada = false 
    var property cantidadEventos = 0 //veces que sufrio eventos
    var property intensidadElevada = 120

    method puedeLiberarse() 
        = self.intensidadEsElevada() && !self.liberada()

    method intensidadEsElevada() 
        = self.intensidad() >= self.intensidadElevada()

    method liberarse(evento) {
        self.disminuirIntensidad(evento.impacto())  
        self.liberada(true)
    }
        
    method aumentarContador() {
        cantidadEventos += 1
    }

    method disminuirIntensidad(cant) {
        intensidad -= cant
    }    
}

object intensidad {//si cambio la intensidad, cambio la intensidad de todas las emociones de todas las personas
    var property intensidadElevada = 100
}

class Furia inherits Emocion { 
    const property palabrotas = []

    override method puedeLiberarse() 
        = super() && self.palabrotasLargas()  

    override method liberarse(evento){
        super(evento) 
        self.olvidarPrimerPalabrota()
    }

    method olvidarPrimerPalabrota(){
        self.olvidarPalabrotra(self.primeraPalabrota())
    }

    method primeraPalabrota() 
        = palabrotas.first()

    method palabrotasLargas() 
        = palabrotas.any({palabrota => palabrota.size() > 7})

    method aprenderPalabrota(palabrota){
        palabrotas.add(palabrota)
    }

    method olvidarPalabrotra(palabrota) {
        palabrotas.remove(palabrota)
    }
}

class Alegria inherits Emocion {

    override method puedeLiberarse() 
        = super() && (self.cantidadEventos() % 2)

    override method liberarse(evento) {
        if(!self.intensidadNegativa(evento.impacto()))
            super(evento)
        else
            self.intensidad(-self.esNegativa(evento.impacto()))
    }

    method intensidadNegativa(intensidadEvento)
        = self.esNegativa(intensidadEvento) < 0

    method esNegativa(intensidadEvento)
        = self.intensidad() - intensidadEvento
}

class Tristeza inherits Emocion{
    var property causa = "melancolia"

    override method puedeLiberarse()
        = super() && self.causa() != "melancolia"

    override method liberarse(evento) {
        super(evento)
        self.causa(evento.descripcion())
    }
}

class DesagradoOTemor inherits Emocion{
    override method puedeLiberarse() 
        = self.cantidadEventos() > self.intensidad() && super()
}

class Ansiedad inherits Emocion{
    const property motivos = [] 

    override method puedeLiberarse() 
        = super() && self.motivos().size() > 3

    override method liberarse(evento) {
        super(evento)
        self.gritar()
    }

    method gritar() {
        self.error("AHHHHHHHHHHHHHHHHHHHHHHHHHHHH")
    }
}
//la herencia fue util para instanciar aquellos metodos que comparten todas clases de emociones
//el polimofirmo es necesario y util ya que al llamar una emocion desde eventos no es necesario especificar cual es, sino que 
//al entender todas las clases de emociones los mismos mensajes, solo preciso un metodo en eventos que interactue con emociones

//-----------------------------------------------------------
//EVENTO
//-----------------------------------------------------------
class Evento {
    const property impacto 
    const property descripcion 

    method vivirEvento(persona) {
      self.liberarEmociones(persona)
    }

    method liberarEmociones(persona) {
        persona.emociones().forEach({emocion => emocion.aumentarContador()})
        self.emocionesQueSePuedenLiberar(persona).forEach({emocion => emocion.liberarse(self)})
    }

    method emocionesQueSePuedenLiberar(persona)
        = persona.emociones().filter({emocion => emocion.puedeLiberarse()})

}
