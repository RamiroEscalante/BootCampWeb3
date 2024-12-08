import Map "mo:map/Map";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Nat16 "mo:base/Nat16";
import Hash "mo:base/Hash";
import Bool "mo:base/Bool";

actor Biblioteca {
  type IDLibro = Text;

  //generamos una estructura/"objeto"
  type Libro = {
    titulo : Text;
    autor : Text;
    genero : Text;
    paginas : Nat16;
    prestado : Bool;
  };

  let libros = HashMap.HashMap<IDLibro, Libro>(0, Text.equal, Text.hash);


  //creamos un libor
  public func crearUnLibro(id : IDLibro, libro : Libro) {
    libros.put(id, libro);
    Debug.print("El libro fue agregado con exito.");
  };

  //mostramos una lista de libros
  public query func obtnerTodosLosLibros() : async [(IDLibro, Libro)] {
    Iter.toArray(libros.entries());
  };

  //leer libro por id
  public query func obternerLibroPorId(id : IDLibro) : async ?Libro {
    libros.get(id);
  };

  //borrar un libro
  public func borrarUnLibro(id : IDLibro) {
    let eliminado = libros.remove(id);
    switch (eliminado) {
        case (?_) {
            Debug.print("El libro fue eliminado con éxito.");
        };
        case null {
            Debug.print("No se encontró un libro con el ID proporcionado.");
        };
    };
  };

  public query func buscarLibroPorGenero(genero: Text): async [Libro] {
        let resultados = Iter.filter(
        libros.entries(),
        func((_, libro): (IDLibro, Libro)): Bool {
            return libro.genero == genero;
        }
    );
    return Iter.toArray(
        Iter.map(resultados, func((_, libro): (IDLibro, Libro)): Libro { libro })
    );
  };

  public func actualizarLibros(id : IDLibro, libroModificado : Libro) {
    switch (libros.get(id)) {
      case (?_) {
        libros.put(id,libroModificado);
      };
      case null {
        Debug.print("Libro no encontrado.");
      };
    };
  };

  //lisatar libros
  public query func listarLibrosPrestados(): async [Libro]{
    let prestamos = Iter.filter(
      libros.entries(),
      func((_,libro): (IDLibro, Libro)): Bool{
        return libro.prestado;
      }
    );
    return Iter.toArray(
      Iter.map(prestamos, func((_,libro): (IDLibro,Libro)): Libro{libro})
    );
  };

  public query func cantidadLibrosPrestados(): async Nat{
    let libroPrestado = Iter.filter(
      libros.entries(),
      func((_,libro): (IDLibro, Libro)): Bool{
        return libro.prestado;
      }
    );
    return Iter.size(libroPrestado);
  };

};
