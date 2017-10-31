view: tag_types {
  sql_table_name: stitch_zendesk.zendesk_tags ;;

  dimension: count {
    type: number
    sql: ${TABLE}.count ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
}