library i18n;

import 'package:get/get.dart';

import 'package:oasx/comom/i18n_content.dart';
import 'package:oasx/utils/extension_utils.dart';
part 'i18n_us.dart';
part 'i18n_cn.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      'en_US': all_us_translate,
      'zh_CN': all_cn_translate,
    };
  }

  late final Map<String, String> all_us_translate = {
    ..._us_base_map,
    ...convertCnToUsMap()
  };

  /// Extract the keys from the Chinese map, remove underscores, and capitalize the first letter of each word to use as the English translation
  Map<String, String> convertCnToUsMap() {
    return all_cn_translate.entries
      .where((e) => !_us_base_map.containsKey(e.key))
      .map((e) => MapEntry(
            e.key,
            e.key.replaceAll('_', ' ').upperFirstWord(),
          ))
      .toMap();
  }

  late final Map<String, String> all_cn_translate = {
    ..._cn_ui,
    ..._cn_menu,
    ..._cn_script,
    ..._cn_restart,
    ..._cn_global_game,
    ..._cn_raid_config,
    ..._cn_invite_config,
    ..._cn_general_battle_config,
    ..._cn_switch_soul,
    ..._cn_orochi_config,
    ..._cn_sougenbi_config,
    ..._cn_fallen_sun_config,
    ..._cn_eternity_sea_config,
    ..._cn_dragon_spine_config,
    ..._cn_area_boss_config,
    ..._cn_gold_youkai_config,
    ..._cn_nian_config,
    ..._cn_talisman_config,
    ..._cn_pets_config,
    ..._cn_simple_tidy_config,
    ..._cn_delegation_config,
    ..._cn_wanted_quests_config,
    ..._cn_tako_config,
    ..._cn_bondling_config,
    ..._cn_evo_zone_config,
    ..._cn_goryou_config,
    ..._cn_exploration_config,
    ..._cn_utilize_config,
    ..._cn_activation_config,
    ..._cn_realm_raid_config,
    ..._cn_missions_config,
    ..._cn_hunt_config,
    ..._cn_true_orochi_config,
    ..._cn_rich_man_config,
    ..._cn_secret_config,
    ..._cn_trifles_config,
    ..._cn_shop_config,
    ..._cn_duel_config,
    ..._cn_general_climb_config,
    ..._cn_meta_demon_config,
    ..._cn_hyakkiyakou_config,
    ..._cn_kokan_config,
    ..._cn_six_realms_config,
    ..._cn_frog_boss_config,
    ..._cn_float_parade_config,
    ..._cn_quiz_config,
    ..._cn_herotest_config,
    ..._cn_abyss_shadows_config,
    ..._cn_find_jade_config,
    ..._cn_guild_banquet_config,
    ..._cn_kitty_shop_config,
    ..._cn_experience_youkai_config,
    ..._cn_demon_encounter_config,
    ..._cn_memory_scrolls_config,
    ..._cn_demon_retreat_config,
    ..._cn_dye_trials_config,
  };
}
