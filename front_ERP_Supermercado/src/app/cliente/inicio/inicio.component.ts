import { Component, inject, input, signal } from '@angular/core';
import { NavbarComponent } from '../components/navbar/navbar.component';
import { CardComponent } from '../components/card/card.component';
import { FooterComponent } from "../components/footer/footer.component";
import { ProductoConPrecio } from '../../../interface/producto.interface';
import { RouterOutlet } from '@angular/router';
import { BitacoraService } from '../../../services/bitacora.service';
import { LoginService } from '../../../services/login.service';
import { User } from '../../../interface/user';
import { UserService } from '../../../services/user.service';

@Component({
  selector: 'app-inicio',
  imports: [NavbarComponent, FooterComponent, CardComponent, FooterComponent,RouterOutlet],
  templateUrl: './inicio.component.html',
  styleUrl: './inicio.component.css'
})
export class InicioComponent {
  private userService=inject(UserService);

  produc: ProductoConPrecio[] = [];

  id_categoria?: string;

  existeUsuario():boolean{
    return this.userService.existeUsuario();
  }

  filtroCategorias(data: any){
    this.borrar = false;
    this.id_categoria = data.id_categoria
    console.log(this.id_categoria);
  }

  borrar : boolean = false;
  borrarFiltro(){
    this.borrar = true;
  }


  ngOnInit(){

  }

}
