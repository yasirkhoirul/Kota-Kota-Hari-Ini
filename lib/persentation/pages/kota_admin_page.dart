import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/search_kota_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/widget/sliverheader.dart';

class KotaAdminPage extends StatefulWidget {
  const KotaAdminPage({super.key});

  @override
  State<KotaAdminPage> createState() => _KotaAdminPageState();
}

class _KotaAdminPageState extends State<KotaAdminPage> {
  @override
  void initState() {
    context.read<SearchKotaCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 800),
        child: BlocBuilder<SearchKotaCubit, SearchKotaState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: Sliverheader(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SearchBar(
                            onSubmitted: (value) {
                              context.read<SearchKotaCubit>().onSearch(value);
                            },
                            hintText: "Cari Kota?",
                            trailing: [Icon(Icons.search)],
                          ),
                        ),
                      ),
                      maxheight: 100,
                      minheight: 80,
                    ),
                  ),
                  state is SearchKotaLoading
                      ? SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : SliverToBoxAdapter(child: Container()),
                  state is SearchKotaError
                      ? SliverToBoxAdapter(
                          child: Center(child: Text(state.message)),
                        )
                      : SliverToBoxAdapter(child: Container()),
                  state is SearchKotaLoaded && state.data.isNotEmpty
                      ? SliverList.builder(
                          itemCount: state.data.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.black,
                              child: ListTile(
                                leading: Container(
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(color: Colors.white),
                              
                                  child: state.data[index].imagePath.isNotEmpty
                                      ? CachedNetworkImage(
                                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                                          imageUrl:
                                              state.data[index].imagePath.first,
                                        )
                                      : Icon(Icons.error),
                                ),
                                title: Text(
                                  state.data[index].namaKota,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.robotoFlex(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  state.data[index].deskripsiSingkat,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.robotoFlex(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: 130,
                                  child: Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                           context.push('/editpage',extra: state.data[index] );
                                        },
                                        child: Text(
                                          "Edit",
                                          style: GoogleFonts.robotoFlex(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Delete",
                                          style: GoogleFonts.robotoFlex(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : SliverToBoxAdapter(
                          child: Center(child: Text("Kota tidak ditemukan")),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
