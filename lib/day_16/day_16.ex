defmodule AoC.Day16 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n", trim: true)
  end

  def part1(input) do
    binary = get_input(input) |> Enum.at(0) |> Base.decode16!()
    read_packet(binary)
  end

  defp read_packet(packet, version_sum \\ 0)

  defp read_packet(packet, version_sum) when bit_size(packet) < 11,
    do: version_sum

  defp read_packet(packet, version_sum) do
    <<version::size(3), type::size(3), rest::bitstring>> = packet

    case type do
      4 ->
        read_packet_type_4(rest, version_sum + version)

      _ ->
        <<length_id::size(1), rest::bitstring>> = rest

        case length_id do
          0 ->
            <<_length::size(15), rest::bitstring>> = rest

            read_packet(rest, version_sum + version)

          1 ->
            <<_num_of_sub_packets::size(11), rest::bitstring>> = rest

            read_packet(rest, version_sum + version)
        end
    end
  end

  defp read_packet_type_4(packet, version_sum) do
    <<last?::size(1), _group::size(4), rest::bitstring>> = packet

    case last? do
      0 -> read_packet(rest, version_sum)
      1 -> read_packet_type_4(rest, version_sum)
    end
  end
end
