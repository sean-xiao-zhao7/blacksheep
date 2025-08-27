//   if (_loading) {
//     return Container(
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage("assets/images/blacksheep_background_full.png"),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Center(child: CircularProgressIndicator(color: Colors.white)),
//     );
//   } else {
//     return StreamBuilder(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (ctx, snapshot) {
//         if (currentGroup == 'chat' && !snapshot.hasData) {
//           return LoginScreen();
//         } else {
//           return SplashScreen();
//         }
//       },
//     );
//   }
