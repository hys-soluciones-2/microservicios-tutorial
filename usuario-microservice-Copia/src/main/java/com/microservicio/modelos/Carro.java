
package com.microservicio.modelos;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 *
 * @author Hugo
 */
@Data
@NoArgsConstructor
public class Carro {

    private String marca;
    private String modelo;
    private int usuarioId;
}
