# TMI
Repositorio para la asignatura Tecnologías Multimedia e Interacción.

### Motivación del proyecto
La motivación principal para la realización de este proyecto es ofrecer la ayuda necesaria a personas con discapacidad visual, permitiendo obtener información del entorno que les rodea. Para ello, el sistema ofrece una descripción por voz sobre los objetos que recoge la cámara trasera de su dispositivo móvil.

Además, esta acuciante crisis afecta de forma directa sobre la vida de las personas con discapacidades, ya que al haber un mayor distanciamiento social de forma general, hay más dificultades a la hora encontrar a una persona dispuesta a ayudar. Por otro lado, muchas personas invidentes no disponen de la posibilidad de acceder a un perro guía, uno de los objetivos de este proyecto es suplir esta necesidad mediante el uso de tecnología multimedia.

Otro aspecto que cabe destacar es que el público objetivo no tiene porque verse limitado a personas con dificultades de visión. En la actualidad, la gente se está mal acostumbrando a mirar el móvil de manera constante mientras pasea por la calle, perdiendo información del entorno que les rodea, lo que propicia que se produzcan más accidentes de tráfico. Aunque este comportamiento sea negativo y el proyecto en sí no lo apoye, todo parece apuntar a una inevitable expansión de este comportamiento social. Este proyecto es versátil y podría ayudar a que se eviten estos trágicos accidentes, con un sistema de alertas que se encargue de avisar al individuo en cuestión.

### Objetivos
Aprender a desarrollar aplicaciones móviles para Android: Buscamos aprender a desarrollar en otras plataformas diferentes a los PC’s, un ejemplo de esto son las apps móviles, que presentan otras características como por ejemplo: una mayor interactividad e intuitividad, suelen tener una mayor dependencia de internet, disponen de menos memoria, etc.

Crecer de manera personal y obtener experiencia: Varios de los miembros de este equipo de trabajo aún no tenemos conocimiento sobre cómo se pueden integrar tecnologías multimedia o interactivas en un sistema software mediante el uso de APIs locales o remotas. Además, este proyecto nos brinda la oportunidad de obtener un mayor conocimiento sobre tecnologías orientadas a la  accesibilidad.

Aportar nuestro granito de arena: Un objetivo y a la vez una motivación es dar una vuelta de tuerca al uso habitual de las tecnologías para ponerlas al servicio de algunas de las personas más necesitadas, en nuestro caso particular, aquellas que tienen algún tipo de discapacidad visual.

### Análisis del proyecto
El proyecto consistirá fundamentalmente en el desarrollo de una aplicación orientada a dispositivos móviles, aunque puede extenderse a wearables empotrados con vistas a facilitar su uso y aumentar su accesibilidad.

Dicha aplicación, a través de una interfaz de uso adaptada a discapacitados visuales, permitirá acceder a una colección de opciones para asistir al usuario en la calle, favoreciendo así su integración social. La funcionalidad principal es la detección de objetos, por medio del análisis de vídeo en tiempo real. El modo de empleo es tan simple como se describe a continuación: activar el sistema y apuntar con la cámara a aquello que se desee reconocer. Así se logra adaptar este tradicional mecanismo a aquellos cuya visión les plantee algún tipo de impedimento, la tecnología actúa en este caso como un traductor sensorial; enviando a los oídos la información que recibirían nuestros ojos.

Los semáforos son solo una pequeña muestra de aquello que dificulta la vida a muchas personas, de hecho resulta imposible utilizar braille para representar, por ejemplo, los grandes carteles empleados para nombrar edificios o comercios. Por ello este sistema también incorpora una opción para ubicar y reconocer texto escrito, para posteriormente reproducirlo mediante síntesis de voz.

Por supuesto, tanto la arquitectura del sistema como su infraestructura física, dan pie a incorporar nuevas aplicaciones para minimizar la brecha social de los discapacitados visuales. Ejemplos serían la detección de pasos de cebra, o de vehículos aproximándose, aunque también personas o animales transitando por la acera. El concepto sigue siendo delegar en una cámara y un computador las tareas que el cuerpo no nos permite realizar.

Más allá este proyecto podría incluso trasladarse a personas no discapacitadas, planteado como una extensión para mejorar su cuerpo humano. ¿Quién no ha escuchado alguna vez eso de tener ojos en el cogote?

### Aproximación del diseño
Para las herramientas software usaremos:
GitHub, para el control de versiones y la gestión de tareas para el modelo del trabajo.
El entorno de desarrollo de Flutter, con el lenguaje de programación Dart en el caso de realizar el desarrollo para Android.

En cuanto a las tecnologías, usaremos dos APIs:
API de MediaPipe para el reconocimiento, en tiempo real, de elementos en vídeos.
API de Google para la lectura de texto.

La arquitectura de la aplicación se dividirá en dos partes, el lado del cliente y el lado del servidor.
La parte del cliente se compondrá de las siguientes partes:
App móvil o aplicación de escritorio.
Diseño (UI / UX): Aplicación simple e intuitiva.
API de MediaPipe: Procesamiento local del video captado por una cámara.
La parte del servidor: Conexión con la API de Google.

### Referencias:
MediaPipe. Available at: https://google.github.io/mediapipe/ (Accessed: 11 March 2021)

iPhone da la mano a los ciegos para cruzar la calle, 2011. Available at:
https://actualidad.rt.com/ciencias/view/32820-iPhone-da-mano-a-ciegos-para-cruzar-calle (Accessed: 11 March 2021)

Jiménez, R., 2017. Una aplicación para móviles ayuda a las personas ciegas a cruzar la calle. Available at:
https://www.cordobahoy.es/articulo/la-ciudad/app-ayuda-personas-ciegas-cruzar-calle/20170420122628026338.html (Accessed: 12 March 2021)

SeeLight: la app que ayuda a los ciegos a cruzar la calle, 2015. Available at: https://www.fundacionmontemadrid.es/2015/10/07/seelight-la-app-que-ayuda-a-los-ciegos-a-cruzar-la-calle/ (Accessed: 12 March 2021)
