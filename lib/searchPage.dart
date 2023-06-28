import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:foodrecipe/recipePage.dart';
import 'package:http/http.dart';
import 'model.dart';


class SearchPage extends StatefulWidget {
  String query;
  SearchPage(this.query);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading=true;

  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchController = new TextEditingController();
  List recipeCatList = [{"imgUrl": "https://images.unsplash.com/photo-1593560704663-f176a2eb61db","heading": "Chilli Food"}];

  getRecipe(String query) async {
    String url = "https://api.edamam.com/search?q=$query&app_id=4d680213&app_key=d32352bd17312a0a54bdb3aa930aebeb";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["hits"].forEach((element){
        RecipeModel recipeModel = new RecipeModel(label: 'label',imageUrl: 'image', url: 'url');
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        setState(() {
          isLoading=false;
        });
        log(recipeList.toString());
      });
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe(widget.query);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff213A50),
                    Color(0xff071938)
                  ],
                )
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24)
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if((searchController.text).replaceAll(" ", "") == "")
                            {
                              print("Blank search");
                            }else{
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchPage(searchController.text)));
                            }
                          },

                          child: Container(
                            child: Icon(
                              Icons.search,
                              color: Colors.blueAccent,
                            ),
                            margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "Let's Cook Something!"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                  child: isLoading ? CircularProgressIndicator() : ListView.builder(
                      shrinkWrap: true,
                      itemCount: recipeList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>RecipePage(recipeList[index].url)));
                          },
                          child: Card(
                            margin: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    recipeList[index].imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ),
                                Positioned(
                                    left: 0,
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black26
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                        child: Text(recipeList[index].label,style: TextStyle(color: Colors.white,fontSize: 20),)
                                    )
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
