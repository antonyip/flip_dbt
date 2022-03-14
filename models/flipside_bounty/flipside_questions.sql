{{
    config(
        materialized="table",
        tags=["flipside"],
    )
}}

with
parsed as (
    select try_parse_json(c1) as parsed_data from community.antonyip.src_bounty_questions
),
question_program_mapping as (
  select 'seltShxaVMcUtsmJ0' as id, 'Terra' as programname
  union select 'selFtI6K0HIG32YoV' as id, 'Art Blocks' as programname
  union select 'selKemDHJWGtTnAHD' as id, 'Compound' as programname
  union select 'selLDckYcmplKKCsI' as id, 'Alchemix' as programname
  union select 'selJ9VpSPUuXYe05m' as id, 'Uniswap' as programname
  union select 'selI5BE2FauUjFP84' as id, 'NFT' as programname
  union select 'selZH7Te5YwicLHL6' as id, 'Pylon' as programname
  union select 'selM50Xob9m9MOcsM' as id, 'Polygon' as programname
  union select 'selghw7HlfhFa19Ze' as id, 'Lido' as programname
  union select 'sel2TEQLUdvJKSnQ4' as id, 'Algorand' as programname
  union select 'selMGtqHjzmLgFNPG' as id, 'Anchor' as programname
  union select 'selxj54LLTfQopOXm' as id, 'Solana' as programname
  union select 'selSQrjTlVejDG28R' as id, 'ConstitutionDAO' as programname
  union select 'selL69UD7e2dJPUs7' as id, 'FWB' as programname
  union select 'selEMZxNLMrvsDqCk' as id, 'Seedclub' as programname
  union select 'selNW07bke0I9FEnk' as id, 'Paraswap' as programname
  union select 'sel4RENEwHPL9BREU' as id, 'Visor' as programname
  union select 'selxDJ708vnXkycm8' as id, 'Yearn' as programname
  union select 'selehXzYQVTgtwtXf' as id, 'AAVE' as programname
  union select 'sel8JEsdqc8Kevt6f' as id, 'Sushiswap' as programname
  union select 'sel9L2DXjIgYxWFfb' as id, 'Levana Protocol' as programname
  union select 'selK29hmbZtwNDVka' as id, 'Stader' as programname
  union select 'sel7Foj1pUCEcShqw' as id, 'Angel' as programname
  union select 'selpiBlJFT61RmXd6' as id, 'MakerDAO' as programname
  union select 'selCCxJdR4AaRBpKy' as id, 'Curve' as programname
  union select 'selXU5AdB7LNBB9mT' as id, 'THORChain' as programname
  union select 'selIiGuAANehGDhVF' as id, 'ENS' as programname
  union select 'selKqM6UbkjKYilbv' as id, 'TracerDAO' as programname
  union select 'seltYIkhG2jvwOqqo' as id, 'Ribbon' as programname
  union select 'seloECqFG5j7NuTeG' as id, 'Orbs' as programname
  union select 'selMREyvIQYnNsy3k' as id, 'BanklessDAO' as programname
  union select 'selRFvbNH35eKZm7M' as id, 'Abracadabra' as programname
),
questions as (
    select 
        parsed_data:cellValuesByColumnId:fldKhkRTdeCnQAWqT::text as questionFull,
        parsed_data:cellValuesByColumnId:fldcwSgEyEpebQ0hz::text as questionTitle,
        parsed_data:cellValuesByColumnId:fldPtdmq7Uf3Ud3sP::text as questionProgram,
        question_program_mapping.programname as decodedquestionprogram,
        parsed_data:cellValuesByColumnId:fldxtpsZEdI7tcxcT::text as questionDescription,
        parsed_data:createdTime::timestamp as questionCreatedTime,
        parsed_data:id::text as airtable_id
    from parsed
    left join question_program_mapping on questionProgram = question_program_mapping.id
)

select * from questions
order by questionCreatedTime desc