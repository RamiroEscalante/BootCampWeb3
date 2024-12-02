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
    titulo: Text;
    autor: Text;
    genero: Text;
    paginas: Nat16;
    prestado: Bool;
  };

  let libros = HashMap.HashMap<IDLibro,Libro>(0,Text.equal,Text.hash);

//creamos un libor
  public query func crearUnLibro(id: IDLibro, libro: Libro){
    libros.put(id, libro);
    Debug.print("El libro fue agregado con exito.");
  };

//mostramos una lista de libros
  public query func obtnerTodosLosLibros(): async [(IDLibro,Libro)]{
    Iter.toArray(libros.entiries());
  };

//leer libro por id
  public query func obternerLibroPorId(id: IDLibri): async ?Libro{
    libros.get(id);
  };

//borrar un libro
  public query func borrarUnLibro(id: IDLibro){
    libros.remove(id);
    Debug.print("El libro fue eliminado con exito.");
  };

  public query func buscarLibroPorGenero(genero: Text): async [Libro]{
    return Iter.toArray(libros.values())
    .filter(func(libro: Libro): Bool{
      return libro.genero == genero;
    });
  };

  public query func actualizarLibros(id: IDLibro, libroModificado: Libro){
    switch(libros.get(id)){
      case (?libro){
        libros.put(libroModificado);
      };
      case null{
        Debug.print("Libro no encontrado.")
      };
    };
  };

  

}