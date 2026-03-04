import "package:flutter/material.dart";

class FolderScreen extends StatelessWidget {
  const FolderScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Folders")),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: (){
                    
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Image.asset("assets/images/spades.png", width: 185, height: 185),
                        Text("Spades")
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Image.asset("assets/images/clubs.png", width: 185, height: 185),
                        Text("Clubs")
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                InkWell(
                  onTap: (){
                    
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Image.asset("assets/images/hearts.png", width: 185, height: 185),
                        Text("Hearts")
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Image.asset("assets/images/diamonds.png", width: 185, height: 185),
                        Text("Diamonds")
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}