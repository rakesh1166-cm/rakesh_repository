import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';

class Influencerscreen extends StatefulWidget {
  const Influencerscreen({super.key});
  @override
  State<Influencerscreen> createState() => _InfluencerscreenState();
}

class _InfluencerscreenState extends State<Influencerscreen> {
  @override

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<InfluencerViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Influencers'),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.influencers.isEmpty
              ? const Center(child: Text('No influencers found'))
              : ListView.builder(
                  itemCount: viewModel.influencers.length,
                  itemBuilder: (context, index) {
                    final influencer = viewModel.influencers[index];
                    return ListTile(
                      title: Text(influencer.userName ?? "No Name"), // Adjust based on your model
                      subtitle: Text(influencer.slug ?? "No Details"), // Adjust based on your model
                    );
                  },
       ),
       
    );
  }
}

